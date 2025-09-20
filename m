Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D23B1DD525
	for <linux-unionfs@vger.kernel.org>; Sat, 20 Sep 2025 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758342689; cv=none; b=gSTI+/PaJLiE04JIo5kP5rfpP48hGdTR/Bz1a84SAzI0Ni57P19SNQqHl8ncH18edPFC2bekT6zT3UWrIdi2mZlXsLViF+GfFnVq7AbjmQEHDxxA3nY1Q/4hkmHUXrxsl0xSLqGnudARO0mzENDhvxUqCJc+kNsudIjPOp8Rnas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758342689; c=relaxed/simple;
	bh=kAny4aRymFDIo+7FPT/ml2qL4nKq50MkuxSYtUo1xdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rg22D1iwgULKE7/zrT7Cva6jlGvJfiK6gpSnCRpw8bVQSL4vYa/FFEBJiU8vL5z+W4kMwNNg35+0QQxJy00UFla2A5dUj+0aNxH5p1bRg2Fq9EEOnXPJIaBX9rdFHMqlYe5OPeaFwRmKae2lKeMsxgYZMZP/gycviaGCS8h+0pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLuGppCK; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLuGppCK"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-4248b320541so6037775ab.1
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Sep 2025 21:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758342686; x=1758947486; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mAMf/yo/OOBBY5X1PTbs08x/sucOGtYlA3nCLcNTs+g=;
        b=fLuGppCK4DAjqW2augM3XZ8Si1RMcFrTAkhTtUvRhH0k/DXAIsFNsnQe33qYOjkDng
         nNwrfJWpcAk++ei1tdRu0b/xa/dqgXyvawOXT8SsK/3ZzsRHv1grK/yp2oAR8fVcAXwR
         aPLMAYcsE04tGb7zBj/O6Qr417zM0P4kI/UM02G3avJZ5HQDfbHVXmexAcnnqoce6IS2
         9FBhY/pEVVjVVg5xdbQ9mKV3F8F4pQOU6bNtMts9IsOZfNrtNgB2MR2fO9OUWzHlSwGv
         rXbKeVem2CeEgaM0ME0xcM9hP7hYEEqA6iIC8ZpUfEdjXSYAS+7rUZe5/gatEBHDMS+Y
         mUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758342686; x=1758947486;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAMf/yo/OOBBY5X1PTbs08x/sucOGtYlA3nCLcNTs+g=;
        b=j8cdOPBYAw1CkK7Tbs3v4Xl9Jc58TC1+RVSQGgmT0Dj8Zdq4Nn2IbE6rhRltr4y87c
         Sol04CeP8r5eSD5c7Qk+r1Zkfh3m1oNO6EQsXa9S6ZaVnw9kdEqcqzAXirZb7xjY5Lpb
         EM598Dw72V3yQTusskeBAHkrHxKCBnhaJqNe8Im3rZx1xv23flpLHApZT4hjS1L9odbk
         IbYnfH+ITlcWJMoEP6fA4OHK5K6FXQAm1caF855g2EOxjCOfUy4BwDNVCFD+p7/MRIcW
         0I4kmS2ILvA2Z6ccgSwRMdxRuvmJ5U/hUSn1F10Vn0Q9/yQj4y19JDnGqgc5n9DKsCSV
         5RYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWsimmNqA+st42WGp1yNNTCsxKk+2KaV15dk5JLo81gm1cMt+IYhuy8Qd0N3ayLxwvgL+SM1J3HHfXDyBu@vger.kernel.org
X-Gm-Message-State: AOJu0YwzA/M6kyAdZytCeGSQqKAD6POoklw5N82A9KaLfTgW05JzmVwB
	UFpboJWo2QtA9g87IavginiDy42BeAGQ9ywCoqLlBy4TPXb3SeZRgGAz
X-Gm-Gg: ASbGncuNfSvAkGXwl9Q41fqkJFGvgW6Bu01hwgYL91UMOjuiXdwPc0xbF5hYRIZnm2z
	fa2kReqR7VFmi2AsPo8SDudxGcz/3Cpqh9WZtnUaRsmElx0KVMtnPMyrOcmYw6sDwJzCpHrLLWJ
	K/teRJZvDf25UTAK/hBBeXay9Ei/uEPs3U8CymzeR2bQlM9aznwARE/nd2J/adQrf9WGw06EE6p
	6CWKs5JLFhAriYGkqzcFQ+3sbZzDfGYCqf0+xPrb9NC5W2MWnK8tfhf2fVL7e1DKK6//PkANtfF
	uK3IdbD4n1TR1mbmTDshImTj8lSYFrcAFtIvZHBiwN2PCkg7yBZls/LoYT58DUzHjFQf+s9Hf4Y
	V5w/EWZXcbuPF4NXNuw3wr0JUkR7X06mM1hIIvQ==
X-Google-Smtp-Source: AGHT+IFcG4QqJ4nlgO3oq0I1YnwOZ/K7SIrMHUnkDcvBmlrkEhfFU8B8mZqzq5hu5cnZ8bWVDrbaVA==
X-Received: by 2002:a05:6e02:156b:b0:424:30f:8e7c with SMTP id e9e14a558f8ab-42481909f5emr98881625ab.10.1758342686244;
        Fri, 19 Sep 2025 21:31:26 -0700 (PDT)
Received: from ?IPV6:2600:6c56:7d00:582f::64e? ([2600:6c56:7d00:582f::64e])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-53d56e429f3sm2997444173.74.2025.09.19.21.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 21:31:24 -0700 (PDT)
Message-ID: <73885a08-f255-4638-8a53-f136537f4b4c@gmail.com>
Date: Fri, 19 Sep 2025 23:31:22 -0500
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] hide ->i_state behind accessors
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com,
 amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-unionfs@vger.kernel.org
References: <20250919154905.2592318-1-mjguzik@gmail.com>
Content-Language: en-US
From: Russell Haley <yumpusamongus@gmail.com>
In-Reply-To: <20250919154905.2592318-1-mjguzik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 10:49 AM, Mateusz Guzik wrote:
> This is generated against:
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs-6.18.inode.refcount.preliminaries
> 
> First commit message quoted verbatim with rationable + API:
> 
> [quote]
> Open-coded accesses prevent asserting they are done correctly. One
> obvious aspect is locking, but significantly more can checked. For
> example it can be detected when the code is clearing flags which are
> already missing, or is setting flags when it is illegal (e.g., I_FREEING
> when ->i_count > 0).
> 
> Given the late stage of the release cycle this patchset only aims to
> hide access, it does not provide any of the checks.
> 
> Consumers can be trivially converted. Suppose flags I_A and I_B are to
> be handled, then:
> 
> state = inode->i_state  	=> state = inode_state_read(inode)
> inode->i_state |= (I_A | I_B) 	=> inode_state_add(inode, I_A | I_B)
> inode->i_state &= ~(I_A | I_B) 	=> inode_state_del(inode, I_A | I_B)
> inode->i_state = I_A | I_B	=> inode_state_set(inode, I_A | I_B)
> [/quote]

Drive-by bikeshedding: s/set/replace/g

"replace" removes ambiguity with the concept of setting a bit ( |= ). An
alternative would be "set_only".

