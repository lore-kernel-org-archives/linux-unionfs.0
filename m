From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 03/23] ovl: store layer index in ovl_layer
Date: Fri, 5 Jan 2018 19:51:48 +0200
Message-ID: <CAOQ4uxg4+CLc_Qj5jX=g=i0cc4kp=S8w_NyQA0uDdHjXWYg4fw@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-4-git-send-email-amir73il@gmail.com> <20180104210018.GB2808@redhat.com>
 <CAOQ4uxjwQ++dQT0w6cVq+BZv3d2cjPvdLLenCAqx-CdSnp3h1g@mail.gmail.com>
 <CAOQ4uxhiSryHmVtRyVCeJPDMbm-9nFqv878VBTz-cUDbbw-A3g@mail.gmail.com> <20180105150025.GB29480@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:33183 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbeAERvt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 12:51:49 -0500
Received: by mail-yw0-f175.google.com with SMTP id k80so2041118ywe.0
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jan 2018 09:51:49 -0800 (PST)
In-Reply-To: <20180105150025.GB29480@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 5, 2018 at 5:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Jan 05, 2018 at 01:22:34PM +0200, Amir Goldstein wrote:
[...]
>
>> 3. Based on the current code, I can post a trivial patch to relax copy up of dir
>>    on encode when ofs->nulower > 1 in case lower dir layer->idx == 1.
>>    Just wasn't sure if that case is worth optimizing, so decided to wait for
>>    comments on the ofs->nulower > 1 behavior.
>
> I must admit, I can't understand this. Please elaborate a bit more.
>

I admit this needs elaborating...

Because middle layers redirects are not "indexed", decoding an overlay
dir file handle that was encoded from a dir in layer > 1 (before copy up)
is complicated and was not implemented in my implementation of NFS export.
The complication is due to the fact that lower dir can have an ancestor in
middle layer above (say in layer 1) that is redirected and we cannot find that
redirect in index.

In V1, NFS export was not supported for ofs->numlower > 1 (lame).
In V2, all dirs are copied up on encode and the upper dir encoded,
so any lower redirect becomes irrelevant when decoding.

Copying up all dirs for ->numlower > 1 to work around middle layer redirects
is a bit of an overkill.
Lower dirs on layer 1 can be exempted from copy up, because they should (*)
not have an ancestor in layer above (upper layer) that is redirected and not
indexed.

So it is easy to apply this relaxing rule if the lower layer index
info is available
in the overlay dir dentry. I did not make that optimization, because I
can't tell
if that will matter to anyone.

(*) NFS export is expected to work well when starting with a clean upper layer
and verify=on, so all copy ups dir and non-dir are indexed. When mounting an
overlay with verify=on, where old non-indexed merge dirs exist, NFS export
will be "best effort", meaning:
- encoding/decoding a non-indexed merge dir works fine whether or not this dir
  is redirected (because decoded upper dir provides the overlay path).
- encoding/decoding a lower dir, whose ancestors is a non-indexed merge dir,
  but NOT redirected works fine (because decoding lower dir yields the
correct path).
- encoding/decoding a lower dir, whose ancestors is a non-indexed merge dir,
  AND redirected will result in -ESTALE

Should probably add a line to documentation about "undefined behavior" when
exporting overlayfs that was not mounted with 'verify=on' to begin with.... and
in the future suggest to run fsck.overlay to index all redirects.

Was I able to clarify more than confusing you??

Amir.
