From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 06/23] ovl: add support for "verify" feature
Date: Tue, 9 Jan 2018 12:44:24 +0200
Message-ID: <CAOQ4uxgzczOomiDb4M4qWf2yS99zq7FWM5eBJD_Axz77dPgOhA@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-7-git-send-email-amir73il@gmail.com> <CAJfpegvsb66k4hhFQfg5vdMRJyA8kqMypOPwaf=C0DeF+2w5ew@mail.gmail.com>
 <CAOQ4uxiXcpd13wua+=g+Uw=zO=QEy5fUA6zGfDqhx3yyOXVcbA@mail.gmail.com> <CAJfpegsCPVgb5Skb2=Ed0Q+zFejQZb9_gvjDhzq1arxOxr+EZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:44463 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbeAIKo0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 05:44:26 -0500
Received: by mail-yw0-f193.google.com with SMTP id x62so1625934ywg.11
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 02:44:25 -0800 (PST)
In-Reply-To: <CAJfpegsCPVgb5Skb2=Ed0Q+zFejQZb9_gvjDhzq1arxOxr+EZQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jan 9, 2018 at 12:07 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Jan 9, 2018 at 10:54 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Jan 9, 2018 at 11:16 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Introduce the "verify" config, module and mount options.
>>>>
>>>> If the "verify" feature is enabled then overlay filesystems will use
>>>> the inodes index dir to verify layers consistency.
>>>>
>>>> It is possible to enable consistency verification by default during
>>>> build time with the OVERLAY_FS_VERIFY config option, during runtime
>>>> with the "verify=on" module option or on a filesystem instance basis
>>>> with the "verify=on" mount option.
>>>>
>>>> The "verify" feature will prevent multiple redirects to the same lower
>>>> dir and will prevent broken hardlinks from using the same inode number.
>>>>
>>>> On an overlay filesystem instance with multiple lower layers, "verify"
>>>> feature can only use the index to prevent multiple redirects from upper
>>>> dirs and not from middle layer dirs. Emit a warning about this on mount
>>>> with multiple lower layers and "verify=on".
>>>
>>> Could the above go into Documentation/filesystems/overlayfs.txt as well?
>>
>> Will do.
>> BTW, are you ok with the feature name "verify" or do you prefer that
>> I rename it to "verify_origin" to be more descriptive as Vivek suggested?
>>
>>>
>>> Also, the verify feature does have some overhead, which should also be
>>> noted in the documentation.  Do you have some measurements about how
>>> much impact it has on performance?
>>>
>>
>> I do not. It's on my TODO list.
>>
>> I'm curious though, where do you think it should performance?
>> I would expect that encoding a file handle and index lookup would not be
>> that expensive, so I don't expect much lookup overhead. No?
>
> I wasn't thinking about anything specific, but now you ask:
> directories always need to be connected, and that results in multiple
> readdirs, etc, that is probably noticeable under some conditions.
>

Right. For the record, there is no decoding of directory file handles
with verify=on expect for ovl_indexdir_cleanup() that could become
optional and expect for decoding an overlay dir file handle for nfsd
of course.

The feature that does decoding of file handles on lookup for snapshots
was separated (per your request) to a different opt-in mount option:
https://github.com/amir73il/linux/commits/ovl-redirect-origin
and is not included in this posting.

Thanks,
Amir.
