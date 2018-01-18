From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v9 14/15] ovl: Fix encryption/compression status of a
 metacopy only file
Date: Thu, 18 Jan 2018 16:32:01 +0200
Message-ID: <CAOQ4uxiLMF6BmzF9hzX6LD7eeX_=-6w1aWir5-d61bj3ojpXxQ@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <20171129155448.32721-15-vgoyal@redhat.com>
 <20180118142453.GA5769@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:38224 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756500AbeAROcD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:32:03 -0500
Received: by mail-yw0-f179.google.com with SMTP id m84so11345724ywd.5
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jan 2018 06:32:02 -0800 (PST)
In-Reply-To: <20180118142453.GA5769@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Jan 18, 2018 at 4:24 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 29, 2017 at 10:54:47AM -0500, Vivek Goyal wrote:
>> If file is metacopy only, it is possible that lower is encrypted while
>> other is not. In that case, report file as encrypted (despite the fact
>> that only data is encrypted while metadata is not).
>>
>> Similarly if lower is compressed, report that in stat for a metacopy
>> only file.
>>
>
> Hi Amir,
>
> Thinking more about this patch. Taking union of lower and upper attributes
> (encryption and compressed) does not feel right.
>
> Right now if lower is compressed and upper is not (metacopy), then we will
> report file as compressed. But if lower is not compressed while upper is,
> still we will report file as compressed. So there is an anomaly here.
>
> I think, compression and encryption primarily represent the data state.
> So always report the state from inode which has file data (lower). And
> don't take union with upper metacopy only inode. Because state in
> upper inode does not matter till data is copied up.
>
> This will also simplify my implementation when supporting metacopy in
> middle layer. That way I don't have to do getattr() on all intermediate
> metacopy inodes in the chain and take a union. Instead I can go to lowest
> most data inode and take encryption and compression attributes from there.
>
> I am not sure why did we decide to take union of lower and upper attrs.
> Right now it does not seem to make sense to me.
>

Now I am not sure either. I suspect that userspace may need the ability to
know if a file is encrypted, but I can't say for sure.
If you want to know better ask the developers that work of fs/crypto.

I don't mind if you leave this patch out.

Cheers,
Amir.
