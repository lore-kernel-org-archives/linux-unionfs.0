From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH v2 4/4] vfs: wrap write f_ops with file_{start,end}_write()
Date: Mon, 6 Feb 2017 16:49:51 +0200
Message-ID: <CAOQ4uximPyi-fno3-ozK_+BekZxxhrUSRk_ZH8kN-dzAjMXreA@mail.gmail.com>
References: <1485174742-15866-2-git-send-email-amir73il@gmail.com>
 <1485200596-14057-1-git-send-email-amir73il@gmail.com> <CAJfpegsL3P-2k=dSWP9XiWKZA3Ywbo0a8TSQ_uS9RkJjqRywRQ@mail.gmail.com>
 <CAOQ4uxg20e_Bb+uVfstJPwZG-9OWerMMzvALL0FuedVgbz5sDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36236 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753189AbdBFOtw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Feb 2017 09:49:52 -0500
In-Reply-To: <CAOQ4uxg20e_Bb+uVfstJPwZG-9OWerMMzvALL0FuedVgbz5sDA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jan 31, 2017 at 9:11 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jan 27, 2017 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Jan 23, 2017 at 8:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Before calling write f_ops, call file_start_write() instead
>>> of sb_start_write().
>>>
>>> This ensures freeze protection for both overlay and upper fs
>>> when file is open from an overlayfs mount.
>>>
>>> Replace {sb,file}_start_write() for {copy,clone}_file_range() and
>>> for fallocate().
>>>
>>> For dedup_file_range() there is no need for mnt_want_write_file().
>>> File is already open for write, so we already have mnt_want_write()
>>> and we only need file_start_write().
>>
>> Being opened for write is not verified if capable(CAP_SYS_ADMIN).
>> Ugly special case, don't ask me why it's done...
>>
>
>
> Miklos,
>
> Your comment was correct, but you applied the patch as is with the
> dedup_file_range()
> change to overlayfs-next regardless. mistake??
>

Ping.
overlayfs-next still hold a wrong patch.
Already posted v3 with some more vfs fixes.


> I was preparing to re-send without the dedup_file_range() bits, but then
> I realized that it is possible to get to fallocate() and copy_file_range() with
> non regular file, so I did not re-send.
>
> I'll re-post with another patch to limit  fallocate() and copy_file_range() to
> regular file in vfs helper.
