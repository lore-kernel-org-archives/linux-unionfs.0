From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Wed, 26 Apr 2017 11:55:44 +0200
Message-ID: <CAJfpeguaePn++tZBvd-2Z68a_8WGfy7EuWLzODyv60E45C6WSQ@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
 <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
 <CAJfpegssdQ4E=uY3bq8zgXLHZsOQaJXpMWtCZ+V=yVM8vmcw5w@mail.gmail.com> <CAOQ4uxgPpnnc5dC+PSuOOWdpnobdKZNzgBzmbeW4Lw6P8_--hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35368 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1431819AbdDZJzv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 05:55:51 -0400
Received: by mail-oi0-f50.google.com with SMTP id j201so202552452oih.2
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2017 02:55:50 -0700 (PDT)
In-Reply-To: <CAOQ4uxgPpnnc5dC+PSuOOWdpnobdKZNzgBzmbeW4Lw6P8_--hg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 26, 2017 at 11:40 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> Just to see that I understand you correctly.
>
> I am now working on storing the following:
>
> /*
>  * The tuple origin.{fh,layer,uuid} is a universal unique identifier
>  * for a copy up origin, where:
>  * origin.fh    - exported file handle of the lower file
>  * origin.root - exported file handle of the lower layer root
>  * origin.uuid  - uuid of the lower filesystem

I wouldn't even store origin.root.

>  *
>  * origin.{fh,root} are stored in format of a variable length binary blob
>  * with struct ovl_fh header (total blob size up to 20 bytes).
>  * uuid is stored in raw format (16 bytes) as published by sb->s_uuid.
>  */
>
> I intend to implement lookup as follows:
> - compare(origin.uuid, same_lower_sb->s_uuid)
> # layer root dentries cannot be DCACHE_DISCONNECTED, so
> # exportfs_decode_fh ignores mnt arg and returns the cached dentry
> - root = exportfs_decode_fh(lowerstack[0].mnt, origin.root)
> - find layer where lowerstack[layer].dentry == root
> - this = exportfs_decode_fh(lowerstack[layer].mnt, origin.fh)
>
> is_subdir() is NOT needed for decoding the layer root
> is_subdir() is optional for decoding the lower file, because
> it is not needed to identify the layer

Hmm, we can just force exportfs_decode_fh() to return a connected
dentry (return false from *acceptable() if the dentry is disconnected)
before going on to iterate the layers to see which one contains it.

Thanks,
Miklos
