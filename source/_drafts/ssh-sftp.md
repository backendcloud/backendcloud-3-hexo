---
title: ssh-sftp
date: 2022-04-29 22:36:21
categories:
tags:
---

```go
import (
	"fmt"
	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
	"io/ioutil"
	"os"
	"path"
	"time"
)

func connectSsh(user string, key []byte, host string, port int) (*ssh.Client, error) {
	var (
		auth         []ssh.AuthMethod
		addr         string
		clientConfig *ssh.ClientConfig
		sshClient    *ssh.Client
		err          error
	)
	// get auth method
	auth = make([]ssh.AuthMethod, 0)
	//auth = append(auth, ssh.Password(password))
	auth = append(auth, publicKeyAuthFunc(key))

	clientConfig = &ssh.ClientConfig{
		User:            user,
		Auth:            auth,
		Timeout:         30 * time.Second,
		HostKeyCallback: ssh.InsecureIgnoreHostKey(), //ssh.FixedHostKey(hostKey),
	}

	// connet to ssh
	addr = fmt.Sprintf("%s:%d", host, port)
	if sshClient, err = ssh.Dial("tcp", addr, clientConfig); err != nil {
		return nil, err
	}

	return sshClient, nil
}

func connectSftp(user string, key []byte, host string, port int) (*sftp.Client, error) {
	var (
		auth         []ssh.AuthMethod
		addr         string
		clientConfig *ssh.ClientConfig
		sshClient    *ssh.Client
		sftpClient   *sftp.Client
		err          error
	)
	// get auth method
	auth = make([]ssh.AuthMethod, 0)
	//auth = append(auth, ssh.Password(password))
	auth = append(auth, publicKeyAuthFunc(key))

	clientConfig = &ssh.ClientConfig{
		User:            user,
		Auth:            auth,
		Timeout:         30 * time.Second,
		HostKeyCallback: ssh.InsecureIgnoreHostKey(), //ssh.FixedHostKey(hostKey),
	}

	// connet to ssh
	addr = fmt.Sprintf("%s:%d", host, port)
	if sshClient, err = ssh.Dial("tcp", addr, clientConfig); err != nil {
		return nil, err
	}

	// create sftp client
	if sftpClient, err = sftp.NewClient(sshClient); err != nil {
		return nil, err
	}
	return sftpClient, nil
}

func publicKeyAuthFunc(key []byte) ssh.AuthMethod {
	//keyPath, err := homedir.Expand(kPath)
	//if err != nil {
	//	fmt.Println("find key's home dir failed", err)
	//}
	//key, err := ioutil.ReadFile(keyPath)
	//if err != nil {
	//	fmt.Println("ssh key file read failed", err)
	//}
	// Create the Signer for this private key.
	signer, err := ssh.ParsePrivateKey(key)
	if err != nil {
		fmt.Println("ssh key signer failed", err)
	}
	return ssh.PublicKeys(signer)
}

func uploadFile(sftpClient *sftp.Client, localFilePath string, remotePath string) error {
	srcFile, err := os.Open(localFilePath)
	if err != nil {
		fmt.Println("os.Open error : ", localFilePath)
		fmt.Println(err)
		return err
	}
	defer srcFile.Close()

	var remoteFileName = path.Base(localFilePath)

	dstFile, err := sftpClient.Create(path.Join(remotePath, remoteFileName))
	if err != nil {
		fmt.Println("sftpClient.Create error : ", path.Join(remotePath, remoteFileName))
		fmt.Println(err)
		return err
	}
	defer dstFile.Close()

	ff, err := ioutil.ReadAll(srcFile)
	if err != nil {
		fmt.Println("ReadAll error : ", localFilePath)
		fmt.Println(err)
		return err
	}
	dstFile.Write(ff)
	fmt.Println(localFilePath + "  copy file to remote server finished!")
	return nil
}

func uploadDirectory(sftpClient *sftp.Client, localPath string, remotePath string) error {
	localFiles, err := ioutil.ReadDir(localPath)
	if err != nil {
		fmt.Println("read dir list fail ", err)
		return err
	}

	for _, backupDir := range localFiles {
		localFilePath := path.Join(localPath, backupDir.Name())
		remoteFilePath := path.Join(remotePath, backupDir.Name())
		if backupDir.IsDir() {
			err := sftpClient.Mkdir(remoteFilePath)
			if err != nil {
				return err
			}
			err = uploadDirectory(sftpClient, localFilePath, remoteFilePath)
			if err != nil {
				return err
			}
		} else {
			err := uploadFile(sftpClient, path.Join(localPath, backupDir.Name()), remotePath)
			if err != nil {
				return err
			}
		}
	}

	fmt.Println(localPath + "  copy directory to remote server finished!")
	return nil
}

func DoBackup(host string, port int, userName string, key []byte, localPath string, remotePath string) error {
	var (
		err        error
		sftpClient *sftp.Client
	)
	start := time.Now()
	sftpClient, err = connectSftp(userName, key, host, port)
	if err != nil {
		fmt.Println(err)
		return err
	}
	defer sftpClient.Close()

	_, errStat := sftpClient.Stat(remotePath)
	if errStat != nil {
		err := sftpClient.Mkdir(remotePath)
		if err != nil {
			return err
		}
	}

	_, err = ioutil.ReadDir(localPath)
	if err != nil {
		fmt.Println(localPath + " local path not exists!")
		return err
	}
	err = uploadDirectory(sftpClient, localPath, remotePath)
	if err != nil {
		return err
	}
	elapsed := time.Since(start)
	fmt.Println("elapsed time : ", elapsed)
	return nil
}

func DoRemoteCmd(host string, port int, userName string, key []byte, cmd string) error {
	var (
		err       error
		sshClient *ssh.Client
	)
	start := time.Now()
	sshClient, err = connectSsh(userName, key, host, port)
	if err != nil {
		return err
	}
	//创建ssh-session
	session, err := sshClient.NewSession()
	if err != nil {
		fmt.Println("创建ssh session 失败", err)
	}
	defer session.Close()
	//执行远程命令
	combo, err := session.CombinedOutput(cmd)
	if err != nil {
		fmt.Println("远程执行cmd 失败", err)
	}
	fmt.Println("命令输出:", string(combo))
	elapsed := time.Since(start)
	fmt.Println("elapsed time : ", elapsed)
	return nil
}
```