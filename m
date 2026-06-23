Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64585218592
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782220304; cv=none; b=tzai6dmb/rPJNsAv3ORrfZqhlU744mF02VgTSVIidqYj81B0EYfHpJj2MPi8hjtxCC8PsNbNFHdlHLXpFVFulHuordIqJ3OswI1Ai6GxovNzqOLLLF1pwN6UMEmJ6Dgdv1X6le7ZqhowwKk80Hc113TvboK7aRY4ZN/xXGGzFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782220304; c=relaxed/simple;
	bh=wRSxTnduN/NeaO0rYAOzLVy/kKGnfywOSzc2EonNrfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jM3nKS8tDsll2v/aCsIwzdEQWM+PQbRAgAi57ngPhZ4n5HKFIesGZiIPNL7v1aGwgdk5nLwuC5bQNOMB+bs8q9nDMtpYuExA2dDOur+Ags6e7uF/VQI1o9pv2i+ZqYOdJ9KXrRkzRqf6shnOqXEg/EXPlu/VuBoYSu3u/cMOk5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pIsx8K9+; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pIsx8K9+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782220292; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sf8nSpVlMBK5Ml0rlJDgAoY39FSY8sMtlk52SjUxZUU=;
	b=pIsx8K9+9Ow9snHWqF7yeBOHQ7/DA+L5u+RYgrIwjifx3hczwDx9Hz96mhFCSutomIX9apBtOq+qa4gH3Hf2vjX1YHiRK/w5NW+PgFe7puYnhylyPDcJJ0BGbjUMp9/8x+DAurGQ+fgDRmnxbZMEtcpbgOZnIRVZjXbCPov1y+0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X5UHLso_1782220290;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5UHLso_1782220290 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 21:11:31 +0800
Message-ID: <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com>
Date: Tue, 23 Jun 2026 21:11:30 +0800
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
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


(+try to cc more FS people for visibility.)

On 2026/6/23 20:47, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 7:59 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2026/6/23 19:38, Yafang Shao wrote:
>>> On Tue, Jun 23, 2026 at 6:25 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/6/23 18:18, Yafang Shao wrote:
>>>>> On Tue, Jun 23, 2026 at 6:12 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>>>
>>>>
>>>> ...
>>>>
>>>>>>
>>>>>> Again, I don't want such customized messy breaks userspace
>>>>>> again; with that patch, container runtime needs to consider
>>>>>> if `volatile` is the default which just breaks the existing
>>>>>> containerd versions.
>>>>>
>>>>> I'll leave this debate to the overlayfs maintainers ;)
>>>>
>>>> On my own perspective and be responsible for common users
>>>> (and as a containerd maintainer [1]),
>>>
>>> No wonder containerd is getting harder and harder to use ;)
>>
>> What do you mean, can you explain exactly?
>>
>> You're just adding a new way to break the existing
>> applications, no? You just breaks previous shipped
>> containerd.
> 
> It's your responsibility to handle the cases where "strict" is
> explicitly required. Please do your homework. It is not the kernel's
> fault.

How do you modify the existing applications and scripts
to adapt your incompatible new Kconfig?

> 
>>
>> Add a way to change the default behavior is fine, but
>> the new default behavior should be worked with the
>> same functionality and compatible, but switching to
>> `volatile` feature is non-compatible and what is why
>> containerd dropped volatile.
> 
> It only adds a dynamically changeable config. Why do you insist it
> breaks everything? Users can always change it whenever they need.

Can you find any Kconfig option that changes user-visible
default functionality and causes almost any user
application that relies on remounting to fail to mount
again? If so, I think we should Cc Linus now.

Thanks,
Gao Xiang
