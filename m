Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07C637757A
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 10:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782210347; cv=none; b=RrnFHamyF2/uk3AfkdRIes7hQq5xpPBALSLEn4yWaFaF7FFrVDq76G2XaddF+PgiH1z/zTaOjtiSCnZQSddeGlScn5gixwy/IAldtkz0fX4ihgM8ZqoM34RZ91LZdjX92O6lZt2DSOMMVjyetvDgJr/VQaO01sJxPxh7LzlS408=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782210347; c=relaxed/simple;
	bh=QTvdG6yMD4Rg5wye/6qDrDiYnm1QRtSr6/VL72kBxWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcfEDLdLPLzrtrJHmAg5KtReVMKGjtZsD+yK/DjMO1Hb/JBaQXhpaGUasn1RiXKeXVilPyrpLZs18jnitUXoJA8ogQscOGtviX1VhbF/7AEDxS7KEW1A1LD+tLXuA2iq8zhjVf0/2kvs6p9DUr1+VCvjpIQqTRBx0OpdhRbFt2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pBKpcxA6; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pBKpcxA6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782210342; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wrL8ONTmvlzzvOlYQoQd2KZ6wbHHA7+Cs4xcAcjIANU=;
	b=pBKpcxA6JxS409h4aV0Q7ycaAxKl9ju75eQWw8Yz48w2mQgifqM90Z0YySGJUwYRGALEDoyrcKs5seqNZ4xyv9R78i1A9WcKAuCCK6DD4RPiFvKA8vx8XaEuPCDTtEfs3N2qwDUNZBmXgxq7w3N2CDw4xdMMFaP81GTpYBQEfUA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5Tq1nY_1782210341;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5Tq1nY_1782210341 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 18:25:41 +0800
Message-ID: <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com>
Date: Tue, 23 Jun 2026 18:25:40 +0800
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
 fuweid89@gmail.com
References: <20260623084337.54344-1-laoar.shao@gmail.com>
 <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com>
 <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com>
 <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com>
 <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/23 18:18, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 6:12 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>

...

>>
>> Again, I don't want such customized messy breaks userspace
>> again; with that patch, container runtime needs to consider
>> if `volatile` is the default which just breaks the existing
>> containerd versions.
> 
> I'll leave this debate to the overlayfs maintainers ;)

On my own perspective and be responsible for common users
(and as a containerd maintainer [1]), if you don't have
a strong argument:

NACKed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

[1] https://github.com/containerd/.project/blob/main/MAINTAINERS#L36

And I don't want:
https://lore.kernel.org/r/CAOQ4uxhfwOU7O_vEQsAvRGV-v3_Dk1RcMnwGx-xOpx-FYjoKcg@mail.gmail.com

happens again.

Thanks,
Gao Xiang

> 

