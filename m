From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 16 Jan 2017 13:19:58 +0200
Message-ID: <CAOQ4uxiPbLCadeRXa19kwF82PVsU75HRCUksjytwkH3qa-ZewQ@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
 <1484488652-611-2-git-send-email-amir73il@gmail.com> <CAJfpegtj7Hmxfmbm=GcNQRgXzpO88pzi5cqk-O1V6QGgCgLMWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34379 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdAPLUA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 06:20:00 -0500
In-Reply-To: <CAJfpegtj7Hmxfmbm=GcNQRgXzpO88pzi5cqk-O1V6QGgCgLMWw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 16, 2017 at 1:00 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sun, Jan 15, 2017 at 2:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Factor out some common vfs bits from do_tmpfile()
>> to be used by overlayfs for concurrent copy up.
>
> I'm wondering whether the vfs helper should do everything except the
> path lookup and the open: d_alloc(), ->tmpfile() and setting
> I_LINKABLE.   This will also aid in doing a ->tmpfile() for overlayfs.
>

I started with that, but slowly trimmed it down to this minimal version.
First, mnt_want_write() can't be in there.
Then dentry * return value would be a strange deviation from other vfs_ helpers.
Lastly, all the open related operations are already performed by
ovl_path_open() and I did not want to make an exception,
so I resorted to doing d_alloc in ovl_alloc_tmpfile(), which becomes
a drop-in replacement for ovl_lookup_temp() and set LINKABLE in
ovl_link_tmpfile(), which becomes a drop-in replacement for ovl_do_rename().
