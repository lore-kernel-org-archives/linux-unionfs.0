From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 16 Jan 2017 16:04:50 +0200
Message-ID: <CAOQ4uxi040SvV=kQUy+pB7CFAjbQPfMVmKRFDjuuL3jeV_fMWA@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
 <1484488652-611-2-git-send-email-amir73il@gmail.com> <CAJfpegtj7Hmxfmbm=GcNQRgXzpO88pzi5cqk-O1V6QGgCgLMWw@mail.gmail.com>
 <CAOQ4uxiPbLCadeRXa19kwF82PVsU75HRCUksjytwkH3qa-ZewQ@mail.gmail.com> <CAJfpegt67Zadny1evdpebdAQ3_QWvFYQgRNkP0O9+7iJta3qpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33054 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdAPOEv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 09:04:51 -0500
In-Reply-To: <CAJfpegt67Zadny1evdpebdAQ3_QWvFYQgRNkP0O9+7iJta3qpQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 16, 2017 at 3:22 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jan 16, 2017 at 12:19 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Jan 16, 2017 at 1:00 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Sun, Jan 15, 2017 at 2:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Factor out some common vfs bits from do_tmpfile()
>>>> to be used by overlayfs for concurrent copy up.
>>>
>>> I'm wondering whether the vfs helper should do everything except the
>>> path lookup and the open: d_alloc(), ->tmpfile() and setting
>>> I_LINKABLE.   This will also aid in doing a ->tmpfile() for overlayfs.
>>>
>>
>> I started with that, but slowly trimmed it down to this minimal version.
>> First, mnt_want_write() can't be in there.
>> Then dentry * return value would be a strange deviation from other vfs_ helpers.
>
> What about lookup_one_len()?  It's not called vfs_something but that's
> beside the point, I think.
>
>> Lastly, all the open related operations are already performed by
>> ovl_path_open() and I did not want to make an exception,
>> so I resorted to doing d_alloc in ovl_alloc_tmpfile(), which becomes
>> a drop-in replacement for ovl_lookup_temp() and set LINKABLE in
>> ovl_link_tmpfile(), which becomes a drop-in replacement for ovl_do_rename().
>
> The logical place to set I_LINKABLE is in vfs_tmpfile().  You are
> arguing about overlayfs code structure, but that's mostly irrelevant
> when doing a new vfs interface.
>

What I tried to do at first is leave d_alloc inside vfs_tmpfile()
and return dentry, but I did not want this interface to deal with struct file
as well.

so do_tmpfile() is very roughly equivalent to:
path_lookupat()
mnt_want_write()
vfs_tmpfile() (including d_alloc)
dentry_open()
inode->i_state |= I_LINKABLE

So I can set LINKABLE inside vfs_tmpfile() only if I also pass
it open_flag and then it would also happen before open returns
success.

My intention was to keep the VFS patch as boring and uncontroversial
as possible.

I am tempted to say: could you possibly create that extra re-factoring yourself
either before or after this patch set? You are the one who is going to
be selling it to
Al after all...

Either that, or just send me better guidelines and I'll do the leg work myself.

Thanks.
