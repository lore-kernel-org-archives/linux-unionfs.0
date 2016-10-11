From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.9
Date: Tue, 11 Oct 2016 21:49:42 +0200
Message-ID: <CAJfpegvQ_24e-mdsazxS5PwVpZ5sBkGfeidk=59Xaw1eJvt1tA@mail.gmail.com>
References: <20161005195210.GC31239@veci.piliscsaba.szeredi.hu>
 <20161005234928.GJ19539@ZenIV.linux.org.uk> <CAJfpegv3TxLbp9TsbXaPdjCFmVDKpvx2y0phSCfjd3B1jcgx4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegv3TxLbp9TsbXaPdjCFmVDKpvx2y0phSCfjd3B1jcgx4w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 6, 2016 at 10:01 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Oct 6, 2016 at 1:49 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Wed, Oct 05, 2016 at 09:52:10PM +0200, Miklos Szeredi wrote:
>>> Hi Al,
>>>
>>> Please pull from:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-viro
>>>
>>> This has an assortment of fixes and cleanups for overlayfs.
>>>
>>> It also touches the VFS:
>>>
>>>  - add the vfs_get_link() helper for calling i_op->get_link();
>>>  - fix mnt_want_write_file() to freeze protect the underlying sb instead of
>>>    overlay sb;
>>>  - allow vfs_clone_file_range() to be called by overlayfs.
>>
>> Could you explain why e.g. fsetxattr() needs a different treatment in
>> "vfs: mnt_want_write_file() should freeze protect underlying sb"?
>
> Because setxattr is an i_op, not a f_op, so it's overlayfs that's
> going to be called and will do the freeze protect on underlying layer
> (not to mention, that it might be a different underlying sb that will
> get the freeze protection in the end, due to copy up)

Hi Al,

Are you okay with the VFS changes in there?  If so could you please
pull and send to Linus?  Or I can send the pull request to Linus
directly, whichever you prefer.

Thanks,
Miklos
