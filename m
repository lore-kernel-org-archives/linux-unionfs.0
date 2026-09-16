Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5727B389E1A
	for <linux-unionfs@vger.kernel.org>; Wed, 16 Sep 2026 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789529407; cv=none; b=q0VTrLEQJUes2v65qKHJhlKC8bv5anTbvTAIuWHAt2zTW1N4g5BU9VR2NuwpLNxSmOKC1Hhb1rJ2DzoHsR+wWuW671QsT+nLdCwfY9EzhMTIKGa1bcmZmuK6qGqNER04lT06YpcK9k5vyqade783hOaekPT96Ep1z3+t5WCtYdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789529407; c=relaxed/simple;
	bh=hUkGjqs6qcYuVfKb4FdP0YcKEPyEotgH3ArbHxEaHSc=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=RFctILZfR87PWCZBTbf4LCIyaKHEhZ2DAam06VN939RTSmkmBUdWHoy1qzdCMORcCa7gEuwMIkP22c5EaZW4NaTzT6ciiBQha/vo0JgDcUEWyz9r0oX8P63e4mAQTJeqD8kf7jd3LvfHIx+iP7bXIIKObYJE3Pj0R1xfCJ4iwOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Hlpw/N0H; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Hlpw/N0H"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910c9ff1fso54737385a.2
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Sep 2026 20:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789529404; x=1790134204; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Til9bgq45pMcrN/mAeyzZMNqicB3+Nb642mFgaUojyw=;
        b=Hlpw/N0HkHsQTYtj7U049Cw8JPDLlHumzPZoCMRvVh47ABqMOdKmPjM/3x/3R3bKBO
         HPYs157NAxLqMOkhAMr2Ta2nSZLPD7YObYHyJqdDqTOTlPlmTwxtC2b2g9pYqaGuhEtK
         6ikSZnxGyzN9HhUvPjqqjnENe2HJe57yFSgPmRRS8TOc0dkvWxRW142W/TKz4GTu4ydT
         R/DgB+IeB/0q4CS9LvEEPQsduNBFZ7aMdxBiesFkoWEZOIAjEhwyqbWzvASoni4zjgOK
         kLJ9oQXTHDilMuHbvuc85vKEhw3XW9rpt8vfVEbxcZOyryESZG2ogmm2hj++uWprY7QO
         Yl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789529404; x=1790134204;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Til9bgq45pMcrN/mAeyzZMNqicB3+Nb642mFgaUojyw=;
        b=vnhJtGaWu5UBUgXm+3pH0F+Mwucf9ChWzclEJ3GGKFWCQSaj76s/lGNe0Cr0z1Yxdn
         +x0f9wpyG9n4TXUXNOZajfuHhl8077qD5KbAOpkll/E7vWVd+SOLJJaJSq2GTuEVIMG5
         m/a6TXUNI/3aRS+NXKwf44mTNpvsD+R4iiomhXBzQqI9Y5XR9qzoyM3Wy/UT0SziPJ6V
         wf7XwTExR/kpWLmYvu+o77sNj0raJjcqE3wwAkF+Fx2SZK1RQjF8EjaYVKsXbwK2rqq9
         Ln+ydnhkhppSq5g8BM0BQMIH+l43veS1BJTiruejyX396gU+p0LP1aFtwFLuFwNYCF3K
         55sg==
X-Forwarded-Encrypted: i=1; AKwUvBwdCCFl5mV50ix7esAZoW3DLU5L4CCo1AGQWxDMH7q1OsgN13nK9cXJ769vc8B2WHQRMXoz/HhW2PxGDIi6@vger.kernel.org
X-Gm-Message-State: AFuF++lINbHfFCM0Jmg1LP+u8sFTsA/8repycYvbB0ZLPRuVTEjRYcg4
	QUTXtSTfAdWLIM7i8ROAJMGSSHOX1PuafbR7eN2SJcx5a5pHrcZjTnKMEx+R/iv7b8QvfX42jWy
	jkWLkuQ==
X-Gm-Gg: AYBFou1S8IOWcqc9xTeHG9sdGeM4Kt6PUqf7jiv9mE2561MJx5wMZTJzy+lKrTQfrjn
	KzrJ0iEetXLXGiqLr3sIR9Xl57geyuPiQNMT2YDiqkWG+VSCbXog5zyOGgBQE0gFtUrixfWrR4n
	6vpugwQDA5OqCkNd5ZZnDBCyYwmCYrV4pZ70JhgXsW+pz34tmiZ8CxukEMxYlunshAZeVbBpZYL
	cxOuyRL4kZI436QtF2WgCJJfBoYkdjEXTB5ntvcLAmECvzyfUpMLQ4bXfWfNkQTVmDhOHGZLLv2
	FL8gAPMpUmVRMhCMxF2AOPwjBuaySFypvg19obLQxpIrWx1Xd+4ZxHyl2oRbuuIeZndwI5mvuFD
	JAqs/SVluT+ht+dD+8fNzdpcQyqci/MCiEBtXTeG9RKatzf++zDht82c3tpEH1O56RW7hZceKrj
	M2AHKBBp9+9ryGHGMe1IzDtfpskrZpWx7sRG+TAYaC1lG6XqaNT3egqAOFL1wdb6owHlnA1OrOp
	m+n7cMUtrN8O2sDt/Fn2fthEEGlfa5AS3JvOwaVrncvo4TswcN5iIEvvC56iXZVXShFl4oIxWaO
X-Received: by 2002:a05:620a:4709:b0:939:35e5:94ba with SMTP id af79cd13be357-93bb766747bmr170559485a.6.1789529404169;
        Tue, 15 Sep 2026 20:30:04 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123be648e5sm15710696d6.8.2026.09.15.20.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 20:30:03 -0700 (PDT)
Date: Tue, 15 Sep 2026 23:30:02 -0400
Message-ID: <d852b4ae61860446e038f69541f36f9c@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260915_1728/pstg-lib:20260915_1318/pstg-pwork:20260915_1728
From: Paul Moore <paul@paul-moore.com>
To: Karl Mehltretter <kmehltretter@gmail.com>, selinux@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, Baokun Li <libaokun@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] selinux: preserve user SID across nested backing  files
References: <20260829213256.51527-2-kmehltretter@gmail.com>
In-Reply-To: <20260829213256.51527-2-kmehltretter@gmail.com>

On Aug 29, 2026 Karl Mehltretter <kmehltretter@gmail.com> wrote:
> 
> SELinux saves the user file SID in a backing-file security blob so it
> remains available after mmap() replaces vma->vm_file with a backing file.
> 
> For nested backing files (overlayfs over overlayfs, or FUSE passthrough
> backed by overlayfs), user_file may itself be a backing file.  Its
> fsec->sid is the SID of the mounter that opened it, rather than the user
> that opened the top-level file.  mprotect() then checks fd { use } against
> the mounter SID.  This can incorrectly deny access without a domain
> transition, or check the wrong target SID after one.
> 
> Copy the saved user SID when user_file is a backing file.  Keep using the
> regular file SID for the first backing layer.
> 
> With two nested overlayfs mounts and SELinux enforcing,
> mprotect(PROT_READ) returns EACCES with an fd { use } denial against the
> mounter SID.  With this change, mprotect() succeeds.
> 
> Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
> SELinux policy.  The original test was also repeated with Fedora Cloud
> Base 44 userspace and gave the same result.
> 
> Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access checks")
> Cc: stable@vger.kernel.org
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> ---
>  security/selinux/hooks.c          | 9 ++++++++-
>  security/selinux/include/objsec.h | 2 +-
>  2 files changed, 9 insertions(+), 2 deletions(-)

Merged into selinux/stable-7.3, thanks!

--
paul-moore.com
