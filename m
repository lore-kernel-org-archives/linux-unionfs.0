Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54923175A9A;
	Wed, 24 Jun 2026 02:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782268095; cv=none; b=Tupc/nlTGq0m35hL5wYxYPiwE5W1DbhzAdXi6ltqSa2pyQsEThcOr5QHg6oUz4slV3t4u3jN+QMbXVezQkIlJVenP+HQRchUT0pcqtINWSG6dcaO1SVZTDQtG8t9IsS9KcUzyDJ0gXQEqEg1B8l9Pcfef2vLoQmQkkCje9tjUJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782268095; c=relaxed/simple;
	bh=B9eE5p9FCEsbRmK985jj06Fk7Z/9OB8xsnV9zXFyMXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ViE4CrcHUuK8d4OzDVx7x+tKAbq8c9FDl5s2ZCuZloJsjnmB3cWpEz9wJxCQSDJKxqsY67Gf4t+yrd8Ss5TuDqDzaq+wUdgDuHhPG6DctVKCbzqJ88jsg/8KGzZZvRAJls2JVl0zINYSSSPJmgGmIe6gn7AT6d/+bHLMLrArPGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fet+Fold; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fet+Fold"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782268088; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7wJ0rpvra3+7b3iwVFvw3R1oKDWs679u5yjPgBIbO3c=;
	b=fet+Fold79naScAMC3VTA7YWKKL5mvjXJh1YXUiADLEFoooRmjEPwD6Wum7KFAeGu+2G8NhmUm91kO5Kcgt47ZFOUAK2lLfGrwNLpLygNjXf2ukgkpkTOC9vZFx8WZY3YrMxByo0IARmWPO9VmkTehtU7cuL6GykO6sSiEOLtmw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X5Vx4EQ_1782268087;
Received: from 30.221.130.136(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5Vx4EQ_1782268087 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Jun 2026 10:28:07 +0800
Message-ID: <f650bed9-b049-4576-bbcf-6dd46028c5a4@linux.alibaba.com>
Date: Wed, 24 Jun 2026 10:28:06 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Yafang Shao <laoar.shao@gmail.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, miklos@szeredi.hu,
 linux-unionfs@vger.kernel.org, fuweid89@gmail.com,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, derek@mcg.dev
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbBjhqKZPqb9r8qoUoYfzpEe6wYU9By_cZtuGGmnoaAa5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/24 10:09, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 10:52 PM Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Tue, Jun 23, 2026 at 3:47 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:

...

> 
> Since the "volatile" option has been working fine for over a year
> across our large fleet of Kubernetes production servers, I submitted
> this change to upstream. In Kubernetes environments, there is no use
> case for remounting the workdir to the same directory, so the volatile
> file won't cause any issues — which is why the "volatile" setting has
> been working well there.
That is not an excuse to introduce such new incompatible behavior
to the linux upstream starting only for your customized fleet and
bother every single opensource user/application to adapt this
behavior which uses overlayfs now.

If you insist to work on a breaking change, please gather
userspace feedback boardly first.

And here I just say you and your employer are lucky since I
know it's also risky even on the generic kubernate perspective.
Please just maintain your livepatch downstream, thanks.

No need to reply, and I won't reply this either, it's just
waste of my time to explain a basic upstream principle again
and again.

Thanks,
Gao Xiang
