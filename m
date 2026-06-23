Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A7435F189;
	Tue, 23 Jun 2026 13:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222457; cv=none; b=Njpgk9ppi4dgMofSm9Ph/TfuGoazsb1Mfgn0zNNlKTpi2PTmRN+GqPA0m9zU0+wwbixC8UfD/0CjbVO08mb43+tQFvve9HmEikVstrcug4J1fb9K3WJ5uD8Bx/nubrk1EdNaJ7TOGcHCy8YVe7mzBXGOIex8Q5OgPbB5X9z8/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222457; c=relaxed/simple;
	bh=MTHnbdrt58RZ+ZqiXe4qambrvNsvFhegF3tpcTw9Whc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VHdlwTyjHe9iRpxsghFLRElA3l4GU4Zrsd+g9nO3hAHpu48DnG+sMkBirDLog9Q5ARTRCGs4EGef9NSUbDTYTf1QNOYT7OeZygqadYYi5MyFYsQ+qLWQtNpurcoktUWtv72KuQNoukebcKzJknNdahIvnoPtiQpb4rrSB7/5Y1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Jr3rS+Fj; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Jr3rS+Fj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782222449; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LF4RgY3iLQ8J1spyToawNxeFwZfhfxA/A+7/RkQxkLI=;
	b=Jr3rS+FjTEL42lFZNPunu+GOI2IgDrFBnv4qMLd8D02zdcgSHop19MKjreb1edkew98K+ceBDJcOpXCHh/O0hgQeoU+Lm5BKzQfowQdJNe7zIWxHmDtin+pkO585mGIftv3zIKPYcTFuaEnU6qbeSpx0xsZGr6esY1qDF83QVN8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5UIc6B_1782222447;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5UIc6B_1782222447 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 21:47:28 +0800
Message-ID: <1cc0931b-648e-4baf-9667-742175b3f9d0@linux.alibaba.com>
Date: Tue, 23 Jun 2026 21:47:27 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Christoph Hellwig <hch@lst.de>
Cc: Yafang Shao <laoar.shao@gmail.com>, miklos@szeredi.hu,
 amir73il@gmail.com, linux-unionfs@vger.kernel.org, fuweid89@gmail.com,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260623134240.GA7980@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 2026/6/23 21:42, Christoph Hellwig wrote:
> I have no idea where this coming from as I can't find an earlier
> version in the fsdevel archives.  But changing user visible mount
> options through konfig options is simply bonkers.
> 
> I'd also like to not that the submitter does have a history of crazy
> patches including those to support proprietary modules and then
> attacking people criticizing those patches, so I can only suggest to
> every maintainer to ignore them for their own sanity.

Sorry about that I didn't Cc the proper list at first,
but it could be checked by using lore:
https://lore.kernel.org/linux-unionfs/20260623084337.54344-1-laoar.shao@gmail.com/T/#u

This topic is very specific to overlayfs details, I'm
not sure how I could say the background in brief.

But almost every single container user uses overlayfs
now, so in order to be responsible for end users,
container runtimes and applications, I used some
aggressive way this time.

Thanks,
Gao Xiang
