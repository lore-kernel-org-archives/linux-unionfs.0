Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <3393f96c-e9a7-2882-f210-81a9c332a138@linux.alibaba.com>
In-Reply-To: <3393f96c-e9a7-2882-f210-81a9c332a138@linux.alibaba.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 5 May 2019 13:44:53 +0300
Message-ID: <CAOQ4uxgkO23o8yPdeu060oeU6CwhvQs9f+R0qFEiQGLA1SdL6w@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5Bbug_report=5D_chattr_=2Bi_succeed_in_docker_which_d?=
	=?UTF-8?Q?on=E2=80=98t_have_the_capability_CAP=5FLINUX=5FIMMUTABLE?=
Content-Type: text/plain; charset="UTF-8"
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, May 5, 2019 at 12:27 PM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
>
> Hi,
>
> We are using kernel v4.19.24 and have found that it can be successful
> when we set IMMUTABLE_FL flag to a file in docker while the docker
> didn't have the capability CAP_LINUX_IMMUTABLE.
>
> # touch tmp
> # chattr +i tmp
> # lsattr tmp
> ----i--------e-- tmp
>
> We have tested this case in older version such as 4.9 and it returned
> -EPERM as expected.
>
> We found that the commit d1d04ef8572b ("ovl: stack file ops") and
> dab5ca8fd9dd ("ovl: add lsattr/chattr support") implemented chattr
> operations on a regular overlay file. ovl_real_ioctl() overridden the
> current process's subjective credentials with ofs->creator_cred which
> have the capability CAP_LINUX_IMMUTABLE so that it will return success
> in vfs_ioctl()->cap_capable().
>
> I wondered is this kind of mechanism of overlayfs or a bug?
>

It's a bug, but I am not sure how to fix it.
If we want to check IMMUTABLE_FL and APPEND_FL permissions
in ovl_ioctl() we need to execute FS_IOC_GETFLAGS on upper
file to know if we are changing those flags.

Note that overlayfs also (never) copied up those flags, so if flags
exist in lower fs they are lost on copy up.
Therefore, if we remove ovl_override_creds() from ovl_real_ioctl()
if lower inode has APPEND_FL it will be removed on copy up
and chattr +S by user without CAP_LINUX_IMMUTABLE will fail
because it will do FS_IOC_GETFLAGS from lower and then
FS_IOC_SETFLAGS that will do copy up and try to set both
APPEND_FL and SYNC_FL on upper inode.

Best I can come up with is store flags in overlay inode on
FS_IOC_GETFLAGS and check changes against stored
flags on  FS_IOC_SETFLAGS. It relies on the fact that
chattr always calls FS_IOC_GETFLAGS before it calls
FS_IOC_SETFLAGS (even with the usage chattr =<flags>).

Want to try and write a patch and test?

Thanks,
Amir.
