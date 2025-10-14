Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61341E990E
	for <linux-unionfs@vger.kernel.org>; Tue, 14 Oct 2025 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760485603; cv=none; b=BmNdkrFFSPrQWCfhFyDJSmrNxEiXPFzfrGwftEuqTP0j70jaMMrjE/gqQ+JzBgoR037qVNFJiBpY3EkTn3qLPN7tajbWvcO0CnUUeqvUP2tzrNCR7THHoh1kkocv38rodo9ybHxe02hqm/6T3aK62h0NJFGmH+CvvmvegzEG/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760485603; c=relaxed/simple;
	bh=LYVfye+2jfXWF34eSuJa02pO1di01Vh1l2AkQHnLeTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FYExNpbbKQ8FMmJg46eYh1LOPjvxr13h9RGZ2pB04X+0R9Md/I6xtkogv1P/l53dSTRzqddF5dCmqeoLJ7N9zHRE11NQ8qcxLBOgc2Vz4ZgqsgsdK13x7ZpOf2Ce7XHH7whlqlsWQbBcpZbJStYmLTAdvX6t4RX3yPUkVYTDLug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+sdaSm6; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+sdaSm6"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3327f8ed081so7360401a91.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Oct 2025 16:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760485601; x=1761090401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vakVPAnhG+s33WW+yk2avQxhwmCtmmfNm1U+3y8SU9U=;
        b=M+sdaSm6ikHxiCKxEBWa65a6P8lemsSNKSOMi3m+0ZRisQaZJiyqX/fUsgE0fJGv5D
         wiMJRAwf2vPV8RMQH4oqsDGzlgIlpDrVdDwU7FkdBAJmwcCluNGuSbE7/axF2PYXI8AO
         2mbkqC8p1vd1bG93X4/p4yr9vf/Ohiks7HtjgODatTjWKt4VQffDTCTqQiILRJ+Hb//3
         q+sl3HYekmYEqIC1yPjcDvP/kc0+RydoUjD6NTMDGYHtgzNKnqXZVX96MCOJ+87O0xxf
         hf/CNyQHZIRYGMzpj3iVxsWMdOBr2fhP55RHxhSWVN8rQ6IekB56Jai55Ei47DoDA0cw
         jP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760485601; x=1761090401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vakVPAnhG+s33WW+yk2avQxhwmCtmmfNm1U+3y8SU9U=;
        b=a0xzkljwJLiLxNAYJdXiuEfVbNu495JYzDvNXosrZwm9L1gxeTamQ/ZvGVOzDuNdya
         DImIOfyID/R6EGJc4vM6B3wjqygsSbf+BaqdxLAKBQdRhPHxhpfeCWsT/F8vWj47DqbL
         cGf3Kuvvs0/dT0QDhBVSiTmvK9YbMjIcfQfwA5eybFYI4Ud8x7zR1TW1/Rb+wJDWSqNF
         pBUuJZEXf0xdEDpKJ7NAiNkV4/Ypp8e6tqEBjY2UNUeB+jdbIMfDLSU4rfyUyvGtkJLN
         kFpwbUHCxwKPdDeTO+jFfRZqSRse+dAWdMpbrj0d9QAkXb+soUCXQQe6qwaZbZhwUeL5
         L4ww==
X-Forwarded-Encrypted: i=1; AJvYcCV4tGyTBZWKmTbaj4J6FUVbIuV0DZz1ZtjtD3XzkZNm5q9yn425hNf8+JtpFk/zowC/sQZXbP0z2G6+RApb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/o7vGtT18WE7CePUla8vEt2/sDeIEp9FO6vZGdahzvYbg8yfg
	DjoOsNsfY8SLh9dXUqEzkXzOgbajzkQ1wANrXGUKzdMCWX3nEIiY7roBe5y9qqXI
X-Gm-Gg: ASbGncsBN3Uke9kMNSPGOVOr/U5ApKhKOH28lWIa4NNLnUCT8ojK+VhFPWUKC6MShiB
	3DqG/linpAuIq4znHK8KSmucOI9dRfUuByvoC+VndtMY/omkxh7lgZU4lDDoirIcAdCMEiT60kp
	RbxSakAuBbN4xHg9H9MXnVFm45WaYV7daVzNcbHySJZWtEpWiwzmI3JDFqzYIxqpDmrj3US8jX2
	5Hd8CwkL8rNR/AcbdezYqWxN7cTojvTABRuS90PXtiGHXvap6eAJnrfMFgvagGkfM8pUrxK+LPW
	q1XTy1XlzLLwAfqwc1gL+pEPQZckwcjjqooYWE21+yMf4Jap6JMq242F4pTOGrkZJCYsNldXeOR
	iw2tJnl/mnPo8RAGHDMSeouno2OrMBmYBehFHuChA+LF9kID/7efQEKPH4V/9cmr7+DQ2oAwVe6
	vG2JoFhBFMvkLz5Pj2D8t8PQ==
X-Google-Smtp-Source: AGHT+IECtas5D0AKF7k+YfLgDtLgwNAopAU187v8QEFHEo1/tzXFB8c6NJkc8BI7xOANIs0x94HcQg==
X-Received: by 2002:a17:90b:1d85:b0:335:28ee:eebe with SMTP id 98e67ed59e1d1-33b5138e625mr35422665a91.30.1760485600940;
        Tue, 14 Oct 2025 16:46:40 -0700 (PDT)
Received: from [10.130.1.37] ([118.200.221.61])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678df2799esm12802604a12.29.2025.10.14.16.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 16:46:40 -0700 (PDT)
Message-ID: <5137ce36-c3b4-4a0a-83af-e00892feaf43@gmail.com>
Date: Wed, 15 Oct 2025 07:46:34 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] ovl: Use fsid as unique identifier for trusted
 origin
Content-Language: en-GB
To: Christoph Hellwig <hch@infradead.org>,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 kernel-dev@igalia.com, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, "Guilherme G . Piccoli"
 <gpiccoli@igalia.com>
References: <20251014015707.129013-1-andrealmeid@igalia.com>
 <20251014015707.129013-2-andrealmeid@igalia.com>
 <aO3T8BGM6djYFyrz@infradead.org>
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <aO3T8BGM6djYFyrz@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14-Oct-25 12:39 PM, Christoph Hellwig wrote:
> On Mon, Oct 13, 2025 at 10:57:07PM -0300, André Almeida wrote:
>> Some filesystem have non-persistent UUIDs, that can change between
>> mounting, even if the filesystem is not modified. To prevent
>> false-positives when mounting overlayfs with index enabled, use the fsid
>> reported from statfs that is persistent across mounts.
> 
> Please fix btrfs to not change uuids, as that completely defeats the
> point of uuids.

We needed cloned device mount support for an A/B testing
use case, but changing the on-disk UUID defeats the purpose.

Right now, ext4 and Btrfs can mount identical devices,
but XFS can't. How about extending this to the common
VFS layer and adding a parameter to tell apart a cloned
device from the same device accessed through multiple
paths? I haven't looked into the details yet, but I can
dig it further.
