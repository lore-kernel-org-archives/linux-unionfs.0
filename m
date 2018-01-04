From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 2/2] nfsd: store stat times in fill_pre_wcc() instead
 of inode times
Date: Thu, 4 Jan 2018 15:47:10 +0200
Message-ID: <CAOQ4uxgYyArCWJ5OHV7WeqYxfGvPMPWzvsm9Jf8+JJ5hPjvVLQ@mail.gmail.com>
References: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
 <1514992475-8142-3-git-send-email-amir73il@gmail.com> <1514994062.3458.14.camel@kernel.org>
 <CAOQ4uxgHwkT=2SGz=XQqP626rfpWCAXtmvBwZuU1N8s1Bh6a4A@mail.gmail.com>
 <1515005144.3458.42.camel@kernel.org> <CAOQ4uxg86oNAYXLN8iCFJTVOV7nxp9a8AwrQPhvr1M-dWqWErA@mail.gmail.com>
 <1515072403.20282.16.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:39582 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752845AbeADNrL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 08:47:11 -0500
In-Reply-To: <1515072403.20282.16.camel@kernel.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 4, 2018 at 3:26 PM, Jeff Layton <jlayton@kernel.org> wrote:
> On Wed, 2018-01-03 at 23:03 +0200, Amir Goldstein wrote:
[...]

>
>> So if I understand you correctly, patch 2/2 is not needed for correctness?
>> Meaning that if overlay inode times are not uptodate, nothing fatal will
>> happen? Or did you mean that I must take care of signalling the client
>> that time values are not reliable for overlayfs?
>>
>> If patch 2/2 is indeed not a must, then I would like to ask you to ACK
>> patch 1/2. It seems quite simple, trivial and harmless to me even  without
>> diving deep into NFS protocols. I think patch 1/2 should be enough for
>> first implementation - it certainly is enough to fix the nfstest_posix failures.
>>
>> Thanks!
>> Amir.
>
> Patch #1 looks fine. I think we ought to wait on #2.
>
> We really should be doing getattrs like this, but when that fails we
> should probably just zero out the wcc / change_info4 at the end rather
> than pretending that it's valid.
>
> I think Bruce or I can take care of that bit after patch #1 is merged.

Great!

Then I'll stack patch #1 along with my overlay nfs export series
with your ACK.

Thanks!
Amir.
