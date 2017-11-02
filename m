From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 3/9] ovl: allocate anonymous devs for lowerdirs
Date: Thu, 2 Nov 2017 15:05:35 +0200
Message-ID: <CAOQ4uxi2qCjOgj=KsmC-VGGj=RDNSR_VkTvLnTxwoZ5okO18rw@mail.gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
 <1509567773-25590-4-git-send-email-amir73il@gmail.com> <20171102122834.GB16677@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:51458 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbdKBNFg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 09:05:36 -0400
Received: by mail-yw0-f193.google.com with SMTP id k3so4680773ywk.8
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 06:05:36 -0700 (PDT)
In-Reply-To: <20171102122834.GB16677@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Nov 2, 2017 at 2:28 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 01, 2017 at 10:22:47PM +0200, Amir Goldstein wrote:
>> From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>
>> Generate unique values of st_dev per lower layer for non-samefs
>> overlay mount. The unique values are obtained by allocating anonymous
>> bdevs for each of the lowerdirs in the overlayfs instance.
>
> Still not sure that why are we allocating anonymous bdev only for
> lower and not upper. Until and unless we have a good reason not not
> do so, treating them in same way will make it atleast easier to
> understand?
>

I too find it hard to understand and to explain why anonymous bdev are needed.
But I really don't see how allocating anonymous bdev for upper makes it easier
to understand...

If you think that it makes the code easier to understand, please show me where,
because I don't see it.
Both in ovl_getattr() and in ovl_lookup(), lower and upper are handled with
completely different code anyway and upper dentry is stored
differently (in overlay
inode) than lower dentry (in overlay dentry).

Anyway, as I wrote, I don't remember if there was a concrete reason why *not*
to allocate anon bdev for upper, or simply that there was no good
reason to *yes*
allocate anon bdev to upper, so need to refer this question to Miklos who
suggested this solution:
https://marc.info/?l=linux-unionfs&m=149259338809700&w=2

Amir.
