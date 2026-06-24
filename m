Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFBC306B3B;
	Wed, 24 Jun 2026 03:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782271055; cv=none; b=VnEaMrfjKx0P6ieo68uFBiSUQS49Cr233fYq/AYQzH/ksRALvkSWyWuZn1sftGDP8WqePUZBZn7wfJ+Kj3I59llFQnYmfg0XnBSEmxSdzT7qL+b3tyZk/cRGCHsdyKtC3TNAqM2HRpfgGOHUHzcuLiV6dxjsjwiBP4oKKT36JP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782271055; c=relaxed/simple;
	bh=/KMM1mjcm/Wl0iFXtei/MIu2O9rQcRAa/9A+tS+TWrw=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:To:
	 In-Reply-To:Content-Type; b=oMxVzuLPTs7ICd/0RDrC+ugr+Drd1YQ6P1veo6B5BN95EBuu4I6nFwCn56cIZXi4ZUvCmI4kHsNcMuwk9mB4Ax7/ulYFuSjhkQT9s37x2unRDpPoyoRZzTi0+6hAgcYrVlPdRBTKU6UkEC3YnJYXSN0raigqUdwJzNqphB5J38Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DfweZVmD; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DfweZVmD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782271049; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=+Mw0Weyp34OBYLRAaq0Yg/Q35eH/W3U3kdrm+xZigmQ=;
	b=DfweZVmDchTfEtnOY545xYEiPqS2Eh2bkfaw5T/QlsRJoI77bk2As1dhC1RQtcgHGMKB3viSRWHTogiO3dqpBlgGiOZYCllJ4b3zr9ld7tl10APYSZBTlC8g4gWEiqsap7fqSx1Hlz5eCF2nLQTWkD1J+SNARCpBUcUtXklWQIU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X5W5S46_1782271048;
Received: from 30.221.130.136(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5W5S46_1782271048 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Jun 2026 11:17:29 +0800
Message-ID: <33912eb8-6b2c-40c2-b698-837e3f675d61@linux.alibaba.com>
Date: Wed, 24 Jun 2026 11:17:28 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>,
 miklos@szeredi.hu, linux-unionfs@vger.kernel.org, fuweid89@gmail.com,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, derek@mcg.dev,
 Yafang Shao <laoar.shao@gmail.com>
References: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com>
 <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com>
 <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com>
 <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
 <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com>
 <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
 <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com>
 <20260623134240.GA7980@lst.de>
 <1cc0931b-648e-4baf-9667-742175b3f9d0@linux.alibaba.com>
 <CAOQ4uxhURfuQWMd3y_W1iFebJms3aohn+koy5_sjxbcc4ZBQ-w@mail.gmail.com>
 <CALOAHbBjhqKZPqb9r8qoUoYfzpEe6wYU9By_cZtuGGmnoaAa5g@mail.gmail.com>
 <f650bed9-b049-4576-bbcf-6dd46028c5a4@linux.alibaba.com>
 <CALOAHbC=2AvZYWEUXR9bk2s=2jk_sVK6zimes1H-TK3iFnn_qQ@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: conduct@kernel.org
In-Reply-To: <CALOAHbC=2AvZYWEUXR9bk2s=2jk_sVK6zimes1H-TK3iFnn_qQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2026/6/24 10:30, Yafang Shao wrote:
> On Wed, Jun 24, 2026 at 10:28 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2026/6/24 10:09, Yafang Shao wrote:
>>> On Tue, Jun 23, 2026 at 10:52 PM Amir Goldstein <amir73il@gmail.com> wrote:
>>>>
>>>> On Tue, Jun 23, 2026 at 3:47 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> ...
>>
>>>
>>> Since the "volatile" option has been working fine for over a year
>>> across our large fleet of Kubernetes production servers, I submitted
>>> this change to upstream. In Kubernetes environments, there is no use
>>> case for remounting the workdir to the same directory, so the volatile
>>> file won't cause any issues — which is why the "volatile" setting has
>>> been working well there.
>> That is not an excuse to introduce such new incompatible behavior
>> to the linux upstream starting only for your customized fleet and
>> bother every single opensource user/application to adapt this
>> behavior which uses overlayfs now.
>>
>> If you insist to work on a breaking change, please gather
>> userspace feedback boardly first.
>>
>> And here I just say you and your employer are lucky since I
>> know it's also risky even on the generic kubernate perspective.
>> Please just maintain your livepatch downstream, thanks.
>>
>> No need to reply, and I won't reply this either, it's just
>> waste of my time to explain a basic upstream principle again
>> and again.
> 
> I'll just go ahead and redirect you to /dev/null ;)

The whole thread is:
https://lore.kernel.org/linux-unionfs/20260623084337.54344-1-laoar.shao@gmail.com/T/#u

Personally, I feel offensive due to Yafang's expression
written above.  I keep maintain my replies in technical
discussion, but the replies above already include the
following words:

"No wonder containerd is getting harder and harder to use ;)"

"Please do your homework."

"Again, pls do your homework."

and the emotional texts `;)` make me feel uneasy over the
time,

especially the final words "I'll just go ahead and redirect
you to /dev/null ;)"

So I write an email as a public report to the CoC since I'm
not sure how to proceed to comment the community patches
because I could get offence as a result.

Thanks,
Gao Xiang
