Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FC035E1CE
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 09:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782206721; cv=none; b=nL8N7VyzKStC8kkPWEeIlcr62uoEGeFTho4UoaaW2EDcVoozwd9qn3tJRw7Z2UYo3P1DITNWU4lzpWElLpG/mWYSajTdNOayAP/a6T6lmP0pW+n8lIhVDnJe7sljnTo+dmW3fodoH99NORTkUI5wT19r31RoT5ysWET5PiX6xpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782206721; c=relaxed/simple;
	bh=3yYtZqVll01L/DjI4YjuKc4irK6fEM1YBAumCoxHmw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o9+T6SGFkRTIyM8Cu4/jy2ht2vpqZr911p5QYCHZgmNBkgyES5dZMArpRVg1vlK/SkvShwQyM+k66qjCKtAy/Ala9DL9GNG/uDfMuuoaUmiI7uttki/0adENHU/NY7HJreqtgVq6AXFfDDR9IJgTbyOS4ll2K57LuU6gQKLHrAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oxsSDCpZ; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oxsSDCpZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782206713; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=q+4M/740H6uTRZyPdnqpwlCV26B7eoI/7gnhc8RbJc8=;
	b=oxsSDCpZaPee2IYDoXaFf4ITui7Pnz0KdIUCM4t81dLb9ymOP46eQT2D7znrFD/BwizmfHbuFd/oJc85jDaRakInvK9dvTDjLiOfzKYURL8h+Ixr896JvSPOFDoib8BGVltmNfDRcwSbXmfX9HOpoLhBakDq5yPcbJ9oeSuLGbM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X5TnWUG_1782206712;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5TnWUG_1782206712 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 17:25:13 +0800
Message-ID: <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com>
Date: Tue, 23 Jun 2026 17:25:12 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org
References: <20260623084337.54344-1-laoar.shao@gmail.com>
 <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/23 17:15, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 5:00 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2026/6/23 16:43, Yafang Shao wrote:
>>> We have enabled "volatile" fsync_mode on our Kubernetes production
>>> environment to prevent container exit from being blocked when there
>>> are many dirty pages to flush. This has worked well without introducing
>>> any issues.
>>>
>>> However, on some of our production servers, upgrading the container
>>> runtime to support the "volatile" mount option is not straightforward [0].
>>> To address this, we want to enable it by default within the kernel.
>>
>> Just a side note: "upgrade the container runtime is not
>> straightforward", how? it seems that issue is already resolved and
>> there is no more discussion.
> 
> We still have many production servers running Docker, while the
> "volatile" mount option is only supported by containerd. Upgrading
> from Docker to containerd is a difficult process.

But docker can be patched too: if upgrading the userspace is
hard, why upgrading the linux kernel is easy?

> 
>>
>> Not quite sure applying a default volatile policy is quite feasible,
>> especially the issue documented in
>> https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
>>
>> then userspace cannot drop `volatile` option as a somewhat
>> workaround now.
> 
> OS vendors can still set "auto" as the default config, while customers
> can override it dynamically via sysfs. We have been running with
> "volatile" on many production servers across different workloads for
> over a year, and it has worked as expected without any issues.

but sysfs setting still applies as system-wide, and there
are some edge cases that we cannot apply volatile as
default, that is my one concern.

The other concern is that since `volatile` omits fsync, so
it's a posix violation (even that makes sense for container
writable layers), not sure if we have to use it as the
system-wide default configuration too.

Thanks,
Gao Xiang

> 

