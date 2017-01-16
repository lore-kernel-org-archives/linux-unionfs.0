From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 16 Jan 2017 14:22:45 +0100
Message-ID: <CAJfpegt67Zadny1evdpebdAQ3_QWvFYQgRNkP0O9+7iJta3qpQ@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
 <1484488652-611-2-git-send-email-amir73il@gmail.com> <CAJfpegtj7Hmxfmbm=GcNQRgXzpO88pzi5cqk-O1V6QGgCgLMWw@mail.gmail.com>
 <CAOQ4uxiPbLCadeRXa19kwF82PVsU75HRCUksjytwkH3qa-ZewQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36372 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdAPNWv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 08:22:51 -0500
Received: by mail-oi0-f68.google.com with SMTP id u143so12442222oif.3
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Jan 2017 05:22:51 -0800 (PST)
In-Reply-To: <CAOQ4uxiPbLCadeRXa19kwF82PVsU75HRCUksjytwkH3qa-ZewQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 16, 2017 at 12:19 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Jan 16, 2017 at 1:00 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Sun, Jan 15, 2017 at 2:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Factor out some common vfs bits from do_tmpfile()
>>> to be used by overlayfs for concurrent copy up.
>>
>> I'm wondering whether the vfs helper should do everything except the
>> path lookup and the open: d_alloc(), ->tmpfile() and setting
>> I_LINKABLE.   This will also aid in doing a ->tmpfile() for overlayfs.
>>
>
> I started with that, but slowly trimmed it down to this minimal version.
> First, mnt_want_write() can't be in there.
> Then dentry * return value would be a strange deviation from other vfs_ helpers.

What about lookup_one_len()?  It's not called vfs_something but that's
beside the point, I think.

> Lastly, all the open related operations are already performed by
> ovl_path_open() and I did not want to make an exception,
> so I resorted to doing d_alloc in ovl_alloc_tmpfile(), which becomes
> a drop-in replacement for ovl_lookup_temp() and set LINKABLE in
> ovl_link_tmpfile(), which becomes a drop-in replacement for ovl_do_rename().

The logical place to set I_LINKABLE is in vfs_tmpfile().  You are
arguing about overlayfs code structure, but that's mostly irrelevant
when doing a new vfs interface.

Thanks,
Miklos
