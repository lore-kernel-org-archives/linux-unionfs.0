Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-28-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-28-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 01:54:53 -0700
Message-ID: <CAOQ4uxifhnk6odkx36a+r-RySu4y_H6e=JAh_kfpR+vBqehZSw@mail.gmail.com>
Subject: Re: [PATCH v14 27/31] ovl: Issue fsync on upper metacopy inode as well
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> When a fsync happens, it calls fsync on real underlying file. If a file
> has been metadata only copied up on upper, then file containing data
> is the real file and fsync will be called on lower data file.
>
> We should be issuing fsync on upper metacopy inode as well to make sure
> upper inode has been made persistent on disk.

This is papering over a bug in Miklos's patch.
fsync should ONLY ever sync upper inode.
same as a bug that was recently fixed in ovl_dir_fsync().

Thanks,
Amir.
