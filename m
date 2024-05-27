Received: from 5.mo552.mail-out.ovh.net (5.mo552.mail-out.ovh.net [188.165.45.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA56738FA6
	for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 12:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.45.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716813354; cv=none; b=ouSPlPzcbtdi9QZOKKpm/131ri/K/YvE8m8T/WO8SMVHhaPMky9o7g6lBnCH7lT632hpY0bT2txCDqlS6UOiJldqc5rS32oEFxog/3rbdKx5kadSQ6NHcfl4XMEGBD+JdSV67IQDoo2rUqNVUo41A3uNQOgx0j3vXdPRVU0MUAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716813354; c=relaxed/simple;
	bh=foRc3sEg+GwE0sP4JCKuSFucu9lt+fNLyfrIbe3CopQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=i4T4BmKtT4U5TmVJmSdRXBlAw9pZwuYLLI4g+eNp7DUTFgi+5GYZWlEFlDEC1C2hnVMH5y01Ht4O2CDIoigqi1BI6yYqNMHH/Eigc31HDYRL7EkvZO97iQ7CN0Oh0ZME3u7t73Zjtml+tX1tB19apy0qQ8OWQg9qS5LjhED1li4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e-gaulue.com; spf=pass smtp.mailfrom=e-gaulue.com; arc=none smtp.client-ip=188.165.45.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e-gaulue.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e-gaulue.com
Received: from mxplan1.mail.ovh.net (unknown [10.109.148.23])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 4Vnw9H0qmRz1L23;
	Mon, 27 May 2024 12:35:47 +0000 (UTC)
Received: from e-gaulue.com (37.59.142.105) by DAG2EX1.mxp1.local (172.16.2.3)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 27 May
 2024 14:35:46 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-105G006fe3587a5-33d3-4d34-9948-8a27c050cb4d,
                    BD7A0CF8D2102731A92987431ED27D8CE5D6B92E) smtp.auth=edouard@e-gaulue.com
X-OVh-ClientIp: 82.66.168.18
Message-ID: <6f871255-a90c-4dce-89d8-0cef0f25f0f0@e-gaulue.com>
Date: Mon, 27 May 2024 14:35:39 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Overlay Filesystem Documentation page
To: Amir Goldstein <amir73il@gmail.com>
CC: <neilb@suse.de>, <miklos@szeredi.hu>, overlayfs
	<linux-unionfs@vger.kernel.org>, Vyacheslav Yurkov <uvv.mail@gmail.com>
References: <a89eab01-6856-49dd-ba5a-942d58d8ebe5@e-gaulue.com>
 <CAOQ4uxjmfSksa7W88B2xq719RdZGGEqvY5OQzZuOMPCmRyG8Ag@mail.gmail.com>
 <9c0ea3be-9022-4b3c-b2ad-8e6e34486092@e-gaulue.com>
 <CAOQ4uxgXiFnvNV7av5dMoF8YS+JPrUM2L91pRXtdZ5gVA5=HFg@mail.gmail.com>
 <cd0a9c43-f3c9-353f-1fcd-f29009c2b8f7@e-gaulue.com>
 <CAOQ4uxjhuhz2=ve2vFydLEg5+-bLrFxDX0ufSf5fOF4wF_y-xQ@mail.gmail.com>
Content-Language: fr
From: =?UTF-8?Q?Edouard_Gaulu=C3=A9?= <edouard@e-gaulue.com>
In-Reply-To: <CAOQ4uxjhuhz2=ve2vFydLEg5+-bLrFxDX0ufSf5fOF4wF_y-xQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CAS2.mxp1.local (172.16.1.2) To DAG2EX1.mxp1.local
 (172.16.2.3)
X-Ovh-Tracer-GUID: d03cba3d-ecd2-43e4-9817-2cf074008d32
X-Ovh-Tracer-Id: 9088827000732919459
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvledrvdejgedgheefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtvdejnecuhfhrohhmpefgughouhgrrhguucfirghulhhurocuoegvughouhgrrhgusegvqdhgrghulhhuvgdrtghomheqnecuggftrfgrthhtvghrnhepleefteehfedvgeegveegfeelueegteffgeffieelgfeltdegtddvgfelvedukeegnecuffhomhgrihhnpehsthgrtghkvgigtghhrghnghgvrdgtohhmpdhgihhthhhusgdrtghomhenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddthedpkedvrdeiiedrudeikedrudeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpegvughouhgrrhgusegvqdhgrghulhhuvgdrtghomhdpnhgspghrtghpthhtohephedprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomhdprhgtphhtthhopehnvghilhgssehsuhhsvgdruggvpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuhhvvhdrmhgrihhlsehgmhgrihhlrdgtohhmpdfovfetjfhoshhtpehmoh
 ehhedvpdhmohguvgepshhmthhpohhuth

Le 25/05/2024 à 09:32, Amir Goldstein a écrit :
> On Thu, May 23, 2024 at 11:56 AM Edouard Gaulué <edouard@e-gaulue.com> wrote:
>> Thanks a lot Amir,
>>
>> Here is a proposal, but consider it as a draft:
>>
>> "
>>
>> Changes to the underlying filesystems while part of a mounted overlay filesystem are not supported. Thought Overlayfs will try to handle those changed files in a way it may not result in a crash or deadlock, you shouldn't do it. Due to multiple reasons involving caches, attributes, and others, if the underlying filesystem is changed, the behavior of the overlay gets "undefined", so you can't trust it anymore.
>>
>> Offline changes (i.e. when the overlay is not mounted) are allowed to the upper tree. But beware of remount after offline changes to the lower tree. They are almost supported if the “metacopy”, “index”, “xino” and “redirect_dir” features have not been used. If the lower tree is modified and any of these features has been used before on this overlay, the behavior can also get "undefined".
>>
> Edouard,
>
> I am sorry to be discouraging, but I personally don't see much value
> in this rephrasing
> and I also don't think that the current documentation is lacking in this point.
> This is my personal opinion and review is a community procedure.
> If there are proponents for this rewrite let them speak up.

Amir,

I agree with you, there is no new ideas, it's just rephrasing of the 
current documentation plus the information you brought in this thread. 
It just makes no way of misinterpretation, reason why I initialy opened 
this thread. For us, moving to overlayfs, it was important we undstand 
better those "offline changes" notions. For the kernel user community, I 
can't say if this rephrasing helps. That is just a CC0 proposal.

>
>> "
>>
>> I came to overlayfs, because of chatGPT. It easily proposes to bind mount between upper and lower. Just say: "I want the feature of overlayfs, but for this specific directory, I want it to write on lower". The provided solution writes on the underlying filesystems (through bind), even if the result is quite predictable and almost works. Now I understand better the way overlayfs is working, I think there should be a warning in the documentation (that chatGPT or others may read next time) regarding this:
>>
> Overalyfs is not the only way to merge directories. This is out of scope.
>
>> "
>>
>> Overlayfs will never write on the lower filesystems, so it will never arm them. But mind the interactions you could create outside of overlayfs using tools like bind mounts, "rsync" or even "cp" between upper filesystem (or merged) and lower ones. Those lead to changes to the underlying filesystems and should be avoided as already stated.
>>
> Sorry. This feels out of scope to me.
> I think the introduction sections describe overlayfs and lower and
> upper layers well enough.

Again, I agree with you. The documentation is quite clear, and once 
again, this proposal is more an important reminder for us, as users, 
than something describing the service.

We tried to look for a good place to get strong informations regarding 
overlayfs usages, but the best we found is the kernel documentation (in 
its last version). All the rest (blogs, "unix.stackexchange.com" or 
"stackoverflow.com") sometime gives misinformation regarding usage. 
Unfortunatly those looks to weight more than the kernel documentation in 
the IA algrotihms (or neural networks) and, of course, that is not the 
kernel documentation responsibility.

In a futur, where indexation wil be replace by IA, I just wonder if RFC, 
documentations, man pages and others shouldn't be more verbose and IA 
oriented. Of course, it's out of the scope of this thread.

>
>> "
>>
>> Finally, I think it would be great to have an option to clean dirs of all previous xattrs set by overlayfs at mount time. Or a command line in the documentation to explain how to get the same. In the meanwhile, I would add:
>>
>> "
>>
>> Note: in those specific cases where data written to the overlay can be recreated without significant effort (like in volatile), you can always recreate an empty upperdir and workdir before remount.
>>
>> "
>>
>> But it doesn't handle the case of those who had bound upper and lower, and decide one day, to use the lower as an upper.
>>
> Sorry, but I am not sure if those details belong in the scope of this document,
> because I don't think we would like to commit to any specific procedure of
> cleaning the upper layer.
>
> I do hear your concerns as a user, but I don't think that better documentation
> alone is going to solve them.
Fully agree.
>
> What overlayfs has always been missing is a counterpart library and user tools
> to deal with those things.
>
> There has been an attempt in the past to start overlayfs-progs [1] and later
> overlayfs-tool2 project [2] to work on offline overlayfs layers.
> I even contributed the "overlay deref" command [3] which partly does what
> you are looking for, but it does not look like this project is
> actively developed
> except for a recent merge of the fsck tool from overlayfs-progs.
Really interesting! I will look at it.
>
> Thanks,
> Amir.
>
> [1] https://github.com/hisilicon/overlayfs-progs
> [2] https://github.com/kmxz/overlayfs-tools
> [3] https://github.com/kmxz/overlayfs-tools/pull/11

Thanks a lot, Amir, your answers have always been helpful. The time you 
can give to answer ours questions will ever be better than the 
documentation.

Regards, Edouard

