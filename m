From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH] ovl:fix rmdir problem on impure dir
Date: Fri, 16 Jun 2017 14:02:06 +0300
Message-ID: <CAOQ4uxinF5y4=1ksyO9-J=GDT0FNBMX+WQ99VABfyYRefA=6+w@mail.gmail.com>
References: <1497585310-34952-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxjnVfY+jqgUxrhw0nD6FHUOaqkTynOQX2cm2MaLRd+cOg@mail.gmail.com>
 <3c7e4be9-03dc-ddeb-9460-87e6c0c6ba83@huawei.com> <CAOQ4uxhj+s=hSHD-185RCBuvXgggnOfdaYxZmstBWp_hsLCbEQ@mail.gmail.com>
 <CAJfpeguRBifj4D1w4REFN1vHsRzdKTXmj8Mk-BHNnHx9vEQyFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33364 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdFPLCH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2017 07:02:07 -0400
Received: by mail-ot0-f194.google.com with SMTP id q16so1211149otb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2017 04:02:07 -0700 (PDT)
In-Reply-To: <CAJfpeguRBifj4D1w4REFN1vHsRzdKTXmj8Mk-BHNnHx9vEQyFw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com

On Fri, Jun 16, 2017 at 12:50 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jun 16, 2017 at 10:55 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Jun 16, 2017 at 10:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> On 2017/6/16 14:02, Amir Goldstein Wrote:
>>>> On Fri, Jun 16, 2017 at 6:55 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>>> Hi All:
>>>>>
>>>>> I found another problem about impure upper dir which have left
>>>>> whiteout files. If an "impure && not merged" upper dir have
>>>>> left whiteout files(last mount created), ovl cannot clear this
>>>>> dir when we removing it, which may lead to rmdir fail or temp
>>>>> file left in workdir.
>
> Thanks for the report and patch.
>
> I think the unlink failures are indicative of a bigger problem,
> though: we optimize directory reading (and empty checking) based on
> the MERGE flag.  This results in the whiteout being returned in the
> directory listing in your test case.

But not only. Now we already check MERGE || (!UPPER && !IMPURE),
so this patch DOES address both empty checking and whiteout filtering
in readdir.

>
> Fortunately we now have a way to identify directories that may contain
> whiteouts: the "overlay.origin" xattr.  So I think we should switch to
> using that instead of the MERGE flag for deciding whether we can use
> real readdir and if we need to check for emptiness by iterating the
> directory.
>

Well, IMPURE can be !ORIGIN and then its a waste to check whiteouts,
but that is a rare case (ORIGIN object moved into pure upper dir).
OTOH, ORIGIN can be !IMPURE (only new files created in merge dir)
and I think that is a more common case, so overall, if we have to choose
from existing flags and not add new ones (i.e. HAS_WHITEOUTS yuck)
then IMO marking IMPURE on whiteout and checking only IMPURE on
readdir is the better option.

Amir.
