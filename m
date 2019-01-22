Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190122050139.19701-1-amir73il@gmail.com> <20190122162852.GA25152@redhat.com>
In-Reply-To: <20190122162852.GA25152@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 22 Jan 2019 19:49:42 +0200
Message-ID: <CAOQ4uxjgRfy8QoS61q-HTkFCNnsikgPFLY0CakLXhN3g9HKB-w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix missing upper fs freeze protection on copy up
 for ioctl
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jan 22, 2019 at 6:28 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jan 22, 2019 at 07:01:39AM +0200, Amir Goldstein wrote:
> > Generalize the helper ovl_open_maybe_copy_up() and use it to copy up
> > file with data before FS_IOC_SETFLAGS ioctl.
> >
> > Fixes: dab5ca8fd9dd ("ovl: add lsattr/chattr support")
> > Cc: <stable@vger.kernel.org> # v4.19
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> What upper fs freeze protection you are referring to. I am unable to
> see it in this new path.
>

Changed from calling ovl_copy_up_with_data() to calling
ovl_maybe_copy_up().
The former doesn't have ovl_want_write()/ovl_drop_write().

The FS_IOC_SETFLAGS ioctl is a bit of an odd ball in vfs,
which probably caused the confusion.
File may be open O_RDONLY, but ioctl modifies the file.
VFS does not call mnt_want_write_file() nor lock inode mutex,
but fs-specific code for  FS_IOC_SETFLAGS does.
So ovl_ioctl() calls mnt_want_write_file() for the overlay file,
and fs-specific code calls mnt_want_write_file() for upper fs
file, but there was no call for ovl_want_write() for copy up
duration which prevents overlayfs from copying up on a
frozen upper fs.

Thanks,
Amir.
