Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F80D378D6B;
	Tue, 23 Jun 2026 13:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782221712; cv=none; b=ZZvtrsVCWguHIW+WcC5xbinbN83lEcyVytOp9JfIsYYLxR4qJ0af8vyrC3mLt06X7QOERPBKJQW+GE+xXHduIvpMbPtON5FUv5QPJML7XkDYDILTdUImxiqqLlVM7KEnlh5XJNIo4SY6ktJaWoxptTkKv5Qc1FTxD5eb0v+MVeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782221712; c=relaxed/simple;
	bh=7ynCMh4y1so1ZQuOBp6iNhoozpwMXLxwiDX1kT8je44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EcWADrTQDsD2dg4z8HCmMt1psb5zmEGlQa/oNukXtu6SZi38oXeeyMI7pFwBfDGNG07IVt/PLYr13ZHnHSiGjhBnxSj4LH5wuXu0flLd//wcID7bPtxKpv5br0RHZYEOltQE5fDgpSiZZMAMa3XlhqbaBmYzkumw28jXibNnjsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LbxEC2aB; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LbxEC2aB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782221705; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5/uoiVQn0/xZaobX/fmqrtj1sCL1h5DTO8R9uZlOaAk=;
	b=LbxEC2aB2NMgEzI1FIvG8kobmu0WQCMDLhw78HJtHDuIvQ71beHbJ/oWuWqEGLfap4Jbb0h6/Yji8/FPXi/812s4LGZWgLoFiyFl2O2zloMzjhJase8ao7ut4t0JRiyXL0dsWUtBYt2jhihHoBXnGm4P+jor8V/OF03PxBrNiWA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5UHRZ5_1782221704;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5UHRZ5_1782221704 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 21:35:05 +0800
Message-ID: <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com>
Date: Tue, 23 Jun 2026 21:35:03 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 fuweid89@gmail.com, Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20260623084337.54344-1-laoar.shao@gmail.com>
 <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com>
 <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com>
 <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com>
 <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com>
 <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com>
 <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
 <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com>
 <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/23 21:19, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 9:11 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>> (+try to cc more FS people for visibility.)
>>
>> On 2026/6/23 20:47, Yafang Shao wrote:
>>> On Tue, Jun 23, 2026 at 7:59 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/6/23 19:38, Yafang Shao wrote:
>>>>> On Tue, Jun 23, 2026 at 6:25 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2026/6/23 18:18, Yafang Shao wrote:
>>>>>>> On Tue, Jun 23, 2026 at 6:12 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>>>>>
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>>>
>>>>>>>> Again, I don't want such customized messy breaks userspace
>>>>>>>> again; with that patch, container runtime needs to consider
>>>>>>>> if `volatile` is the default which just breaks the existing
>>>>>>>> containerd versions.
>>>>>>>
>>>>>>> I'll leave this debate to the overlayfs maintainers ;)
>>>>>>
>>>>>> On my own perspective and be responsible for common users
>>>>>> (and as a containerd maintainer [1]),
>>>>>
>>>>> No wonder containerd is getting harder and harder to use ;)
>>>>
>>>> What do you mean, can you explain exactly?
>>>>
>>>> You're just adding a new way to break the existing
>>>> applications, no? You just breaks previous shipped
>>>> containerd.
>>>
>>> It's your responsibility to handle the cases where "strict" is
>>> explicitly required. Please do your homework. It is not the kernel's
>>> fault.
>>
>> How do you modify the existing applications and scripts
>> to adapt your incompatible new Kconfig?
> 
> Why do you still insist it's "incompatible"? As far as I can see,
> mounting on the same directory is a very rare case, especially in
> production environments. If your use case relies on "strict", then
> simply don't turn it on. Everything across our large fleet of servers
> works perfectly well with it.

I've listed my reasons since this patch is really a red
line for me (otherwise I won't comment your patch, it's
none of my business.) and I've said enough, and the
upstream kernel + overlayfs does not work only for your
company:

You should first ask and gather how many existing
applications which can mount overlayfs will deal with
your new Kconfig; if not, what is the target audience
of your opt-in Kconfig other than your company as a way
to workaround "docker" upgrade.

Or if you'd like to introduce a new incompatible "overlayfs"
(an overlayfs cannot mount again by design + volatile by
default), I think we should name it as another fstype in
order to avoid breaking existing applications.

> 
>>
>>>
>>>>
>>>> Add a way to change the default behavior is fine, but
>>>> the new default behavior should be worked with the
>>>> same functionality and compatible, but switching to
>>>> `volatile` feature is non-compatible and what is why
>>>> containerd dropped volatile.
>>>
>>> It only adds a dynamically changeable config. Why do you insist it
>>> breaks everything? Users can always change it whenever they need.
>>
>> Can you find any Kconfig option that changes user-visible
>> default functionality and causes almost any user
>> application that relies on remounting to fail to mount
>> again? If so, I think we should Cc Linus now.
> 
> I can't get you.
> 

