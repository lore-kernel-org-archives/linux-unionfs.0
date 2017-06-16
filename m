From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] ovl:fix rmdir problem on impure dir
Date: Fri, 16 Jun 2017 11:50:31 +0200
Message-ID: <CAJfpeguRBifj4D1w4REFN1vHsRzdKTXmj8Mk-BHNnHx9vEQyFw@mail.gmail.com>
References: <1497585310-34952-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxjnVfY+jqgUxrhw0nD6FHUOaqkTynOQX2cm2MaLRd+cOg@mail.gmail.com>
 <3c7e4be9-03dc-ddeb-9460-87e6c0c6ba83@huawei.com> <CAOQ4uxhj+s=hSHD-185RCBuvXgggnOfdaYxZmstBWp_hsLCbEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36070 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753060AbdFPJud (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2017 05:50:33 -0400
Received: by mail-ot0-f196.google.com with SMTP id r67so3778498ota.3
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2017 02:50:32 -0700 (PDT)
In-Reply-To: <CAOQ4uxhj+s=hSHD-185RCBuvXgggnOfdaYxZmstBWp_hsLCbEQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com

On Fri, Jun 16, 2017 at 10:55 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jun 16, 2017 at 10:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/6/16 14:02, Amir Goldstein Wrote:
>>> On Fri, Jun 16, 2017 at 6:55 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>> Hi All:
>>>>
>>>> I found another problem about impure upper dir which have left
>>>> whiteout files. If an "impure && not merged" upper dir have
>>>> left whiteout files(last mount created), ovl cannot clear this
>>>> dir when we removing it, which may lead to rmdir fail or temp
>>>> file left in workdir.

Thanks for the report and patch.

I think the unlink failures are indicative of a bigger problem,
though: we optimize directory reading (and empty checking) based on
the MERGE flag.  This results in the whiteout being returned in the
directory listing in your test case.

Fortunately we now have a way to identify directories that may contain
whiteouts: the "overlay.origin" xattr.  So I think we should switch to
using that instead of the MERGE flag for deciding whether we can use
real readdir and if we need to check for emptiness by iterating the
directory.

Thanks,
Miklos
