Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Mon, 12 Mar 2018 15:38:52 +0800
Message-ID: <CALLuPvoJ_Eb4C9g4ouo97MUYAbYC0yJX0qVfJzihj2EGA5tbGQ@mail.gmail.com>
Subject: flock fails in overlay nfs-exported file
Content-Type: text/plain; charset="UTF-8"
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hello Miklos,
I'd like to report a flock(2) problem to overlay nfs-exported files.
The error return from flock(2) is "Bad file descriptor".

Environment:
OS: Ubuntu 14.04.2 LTS
Kernel: 4.16.0-041600rc4-generic (from
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16-rc4/)

Reproduce step:
(nfs server side)
mount -t overlay
-orw,lowerdir=/mnt/ro,upperdir=/mnt/u,workdir=/mnt/w,nfs_export=on,index=on
none /mnt/m
touch /mnt/m/foo
(nfs client side)
mount server:/mnt/m /mnt/n

flock /mnt/n/foo
failed to lock file '/mnt/n/foo': Bad file descriptor

The simple flock(2) wrap program is:
int main(int argc, void **argv) {
char *filename=argv[1];
int fd = open(filename, O_RDONLY);;
int flock_result = flock(fd, LOCK_EX | LOCK_NB);
if (flock_result != 0) {
      printf("failed to lock file '%s': %s\n", filename, strerror(errno));
      goto out;
    }
    printf("flock succeed\n");
out:
    close(fd);
}

Thanks!
