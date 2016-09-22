From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 4/4] ovl: use vfs_copy_file_range() to copy up file data
Date: Thu, 22 Sep 2016 16:49:35 +0200
Message-ID: <CAJfpeguhoMkkBWD7s6V-2jHaAvKrEn+sz8h0emcr7isR8yzKHg@mail.gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-5-git-send-email-amir73il@gmail.com> <CAOQ4uxjhO0M4K4oNA0dGsN6-DHtJ7zFQVLe=T2qpuWb+eubaig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjhO0M4K4oNA0dGsN6-DHtJ7zFQVLe=T2qpuWb+eubaig@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 22, 2016 at 10:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Guys, I just hit a lockdep warning on nesting an mnt_want_write() with
> this patch
> because overlay already holds the write lock when getting to ovl_copy_up_data()
> I don't know how I missed it before.
>
> Is it really a problem to nest this lock?
> Should I factor our another set of _locked helpers from the
> vfs_{copy,clone}_file_range helpers?
>

vfs_{copy,clone}_file_range should call sb_start_write() instead of
mnt_want_write_file(), the checks against FMODE_WRITE + S_ISREG ensure
that the __mnt_want_write() part is already held on the file.

That still leaves the lockdep warning.  We could do
__vfs_{copy,clone}_file_range() variants without the
sb_start_write()/sb_end_write() and add the non-underscore variants as
static inline to fs.h that do call the sb_start/end_write.

Thanks,
Miklos
