From: hujianyang <hujianyang@huawei.com>
Subject: Re: Allow non-workdir mount in overlayfs?
Date: Wed, 14 Jan 2015 18:18:35 +0800
Message-ID: <54B6427B.6010908@huawei.com>
References: <54B5D862.3010600@huawei.com> <CAJfpegsCdRkw6unNM5txd8ZJvvw-X=v_LEw=iMVUvDPox1O_EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:7807 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbANKTU (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 14 Jan 2015 05:19:20 -0500
In-Reply-To: <CAJfpegsCdRkw6unNM5txd8ZJvvw-X=v_LEw=iMVUvDPox1O_EA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Seunghun Lee <waydi1@gmail.com>, linux-unionfs@vger.kernel.org

On 2015/1/14 17:55, Miklos Szeredi wrote:
> On Wed, Jan 14, 2015 at 3:45 AM, hujianyang <hujianyang@huawei.com> wrote:
>> Hi Miklos,
>>
>> I was considering the "FIXME: workdir is not needed for a R/O mount"
>> you left in ovl_fill_super() these days.
>>
>> Actually Seunghun (Seunghun Lee <waydi1@gmail.com>) has sent a patch
>> about these problem. But I have some different ideas. I think there are
>> two ways to fix this problem. One, just remove this *FIXME*. Another,
>> Allow non-workdir mount.
>>
>> 1) Remove *FIXME*; Further, use workdir in R/W case only
>>
>> As multi-layer mount are allowed in ovl, users could initialize a R/O
>> mount by setting multi lower directories. Workdir should only be used
>> in R/W case with upperdir exist. So this *FIXME* can be removed.
>>
>> We should add some information in the code and document about this.
> 
> I'd vote for this.
> 
> If there's no workdir, just use multiple lowedirs.
> 
> If there is a workdir, then specify it (and overlay can still be
> mounted R/O, possibly remounted R/W)
> 

Got it~!

I'd like to send a patch about it tomorrow.

By the way, I think we should add a error message in parse_opt,
see the mail send by Fabian, do you agree with it?

Thanks,
Hu


