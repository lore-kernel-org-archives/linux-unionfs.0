Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F8130B53A;
	Wed, 24 Jun 2026 03:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782272172; cv=none; b=X4WaPOelsoVDP2bdB+OJloiWxjm28+FA53wsvwVuktmv59/vh1CXs3S2JkNmdexqm3Z1kqaHUTC/hhQIFzEJRbKaaL0Y1uajjdgdn9pS93yUxMDknAhDAVp3rqj1x1xRJ6nOdzEhwqtqoPMATok6Cj0mEYEKqcLswTA+IUZzW1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782272172; c=relaxed/simple;
	bh=RNML7MlJyODLQ0zRLyqpElUQAflAiG5IZQLIzztEJqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KgGPiBeJ5ApMsrVO18PY/MG8XmPq0PotwRt+sL5Xw4MnN9hMbfEbKA76XEex5ziOHnOTSsSVWFtHsxm0NSRzhkqlET1o6sldmAPKY3Wgf3sikfr26UoDQ7z4dx+0CXMLwo1hkKkO0r55xGhpaaON73M8pJK3KHb1rkKiLO0Cylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YNJGo6+W; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YNJGo6+W"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782272167; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CKG1oZt0igmXKlZAR7BTeLvg1KR8HR5ynNKdkQnXYpY=;
	b=YNJGo6+WjzvpQg+gMkZL+LbcpVVUmcuGNJ3qiEjxVLRVXeH6RjJOLB3kJAe6Vw6g0dpNlNhghvr0m4fO9W2yCmsuRICt4FjDqnMxdl1XP0OuPoFf8jItsZ6z53XFhHNtFVCdo2L0AAxIEPC2ty7UiA68vyhpxZEFYOTOd3aO6jw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X5WKW7A_1782272166;
Received: from 30.221.130.136(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5WKW7A_1782272166 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Jun 2026 11:36:07 +0800
Message-ID: <56cdf083-99e9-4656-a353-f4d4670917b8@linux.alibaba.com>
Date: Wed, 24 Jun 2026 11:36:06 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: conduct@kernel.org, Amir Goldstein <amir73il@gmail.com>,
 Christoph Hellwig <hch@lst.de>, miklos@szeredi.hu,
 linux-unionfs@vger.kernel.org, fuweid89@gmail.com,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, derek@mcg.dev
References: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
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
 <33912eb8-6b2c-40c2-b698-837e3f675d61@linux.alibaba.com>
 <CALOAHbDrWR0eRF9gST14Vm3xOimDZ=iLdn0zRFiF7OeBtqOD=A@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbDrWR0eRF9gST14Vm3xOimDZ=iLdn0zRFiF7OeBtqOD=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/24 11:28, Yafang Shao wrote:
> On Wed, Jun 24, 2026 at 11:17 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> Hi,
>>
>> On 2026/6/24 10:30, Yafang Shao wrote:
>>> On Wed, Jun 24, 2026 at 10:28 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/6/24 10:09, Yafang Shao wrote:
>>>>> On Tue, Jun 23, 2026 at 10:52 PM Amir Goldstein <amir73il@gmail.com> wrote:
>>>>>>
>>>>>> On Tue, Jun 23, 2026 at 3:47 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>
>>>> ...
>>>>
>>>>>
>>>>> Since the "volatile" option has been working fine for over a year
>>>>> across our large fleet of Kubernetes production servers, I submitted
>>>>> this change to upstream. In Kubernetes environments, there is no use
>>>>> case for remounting the workdir to the same directory, so the volatile
>>>>> file won't cause any issues — which is why the "volatile" setting has
>>>>> been working well there.
>>>> That is not an excuse to introduce such new incompatible behavior
>>>> to the linux upstream starting only for your customized fleet and
>>>> bother every single opensource user/application to adapt this
>>>> behavior which uses overlayfs now.
>>>>
>>>> If you insist to work on a breaking change, please gather
>>>> userspace feedback boardly first.
>>>>
>>>> And here I just say you and your employer are lucky since I
>>>> know it's also risky even on the generic kubernate perspective.
>>>> Please just maintain your livepatch downstream, thanks.
>>>>
>>>> No need to reply, and I won't reply this either, it's just
>>>> waste of my time to explain a basic upstream principle again
>>>> and again.
>>>
>>> I'll just go ahead and redirect you to /dev/null ;)
>>
>> The whole thread is:
>> https://lore.kernel.org/linux-unionfs/20260623084337.54344-1-laoar.shao@gmail.com/T/#u
>>
>> Personally, I feel offensive due to Yafang's expression
>> written above.  I keep maintain my replies in technical
>> discussion, but the replies above already include the
>> following words:
>>
>> "No wonder containerd is getting harder and harder to use ;)"
>>
>> "Please do your homework."
>>
>> "Again, pls do your homework."
>>
>> and the emotional texts `;)` make me feel uneasy over the
>> time,
>>
>> especially the final words "I'll just go ahead and redirect
>> you to /dev/null ;)"
>>
>> So I write an email as a public report to the CoC since I'm
>> not sure how to proceed to comment the community patches
>> because I could get offence as a result.
> 
> I believe you could learn a thing or two from Amir about how to
> comment on others' patches ;)

;) Please let me know why you commented:

"No wonder containerd is getting harder and harder to use ;)"

;)

Thanks,
Gao Xiang

> 

