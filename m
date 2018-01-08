From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v9 10/15] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Mon, 8 Jan 2018 17:21:23 +0100
Message-ID: <CAJfpegt5pfP=ESvfbeRwgYrB=fNXfzeO-ni6RWZ13g6D5imBQw@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <20171129155448.32721-11-vgoyal@redhat.com>
 <CAJfpegtc-63zQS+_j1sKB48fXSz63nT4hH0Q09brLWHbaC5KKg@mail.gmail.com> <20180108161745.GB13708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:42549 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756259AbeAHQVY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 11:21:24 -0500
Received: by mail-qt0-f179.google.com with SMTP id g9so14239435qth.9
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jan 2018 08:21:24 -0800 (PST)
In-Reply-To: <20180108161745.GB13708@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

On Mon, Jan 8, 2018 at 5:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Jan 08, 2018 at 04:50:00PM +0100, Miklos Szeredi wrote:
>> On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Now we will have the capability to have upper inodes which might be only
>> > metadata copy up and data is still on lower inode. So add a new xattr
>> > OVL_XATTR_METACOPY to distinguish between two cases.
>>
>> Maybe I missed something, but I think there's a bug in this patch:
>> truncate() is a metadata+data operation since it affects results of
>> read().  So it should be handled by doing the data copy-up like we did
>> before.
>
> Hi Miklos,
>
> For truncate operation, we don't do metadata only copy up and fall back
> to regular operation.
>
> ovl_need_meta_copy_up() {
>         if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
>                 return false;
>
> }
>
> So behavior should not change with metacopy for truncate operation.
>
> Am I missing something?

I'm talking about truncate(2).  That will bypass opening the file
completely, going only through ovl_setattr(), which will do a metadata
only copy up (AFAICS).

Thanks,
Miklos


>
> Thanks
> Vivek
