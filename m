Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0EB379ED6
	for <linux-unionfs@vger.kernel.org>; Wed, 16 Sep 2026 03:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789529411; cv=none; b=bkIw6euEs83cHau0KFc8OxAghd1vGzQL7vW2lS0Kd5Gewk/RVTEJ+tWddAH13JeDrWGod21NZW+/8vBdq2/79bnZREDqqvQNMpTCGWNd5d6vZG7DsYsEXZ7wG5JVhNiHBQRQB13YPNuOyGT9NGoLDoHALZ0IOEUtdtLyjtIYctw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789529411; c=relaxed/simple;
	bh=lADoJEvJwLqad1Os9IZPoKdohrwVmSPNwKLow4aYg5Q=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=VpNDyL94+PM8yRoXc2Twt0upn2kSHpxGCgSyXX48yiLEpkYaQ2H66CpDpqXJjjziPRpwG161BTl9gDVvPTc/44AUwOCv4gOw5zADcgzrZfDUlKQTejNotWWWpPz9JTlbvbVWMlyasmTp9sVUvzJSfWVNbOrzio4VSAq2JqEpWSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=OH7+hthr; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="OH7+hthr"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76c9deeso5931531cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Sep 2026 20:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789529407; x=1790134207; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2bm31ePa7WsV8qeFRceTtEGTceD7Q/MB+XojEjfCZKc=;
        b=OH7+hthrzUpNeHKYeYOdtaWhni6Isql8vs2c0NKuX2NCWCbAI5wCrK2wt8OT8DqDHh
         8Gi53QBJ/6Zo9Tw8M4+KwkjWgeNIQpLoTKmQuom/wd0+/NLAG8ltlBrwcwddIlmxTg6Z
         8RtoohipTkW00LsL/fcLpylbxVHXJxkcSn4gOsfE2p4633GUSiJJ5+f+aGqLU0Y85tYR
         c6/TAle8X2TbiqyNNhhKIfFjq0Yh5Nu8DxIjXwLWWwP/us9kBevxJ1n0hwG1x/igfytA
         35UzFKqsCGhJiGCgOYjunMhQOpgSgeiMpFkGSJKeyFmeC0N9A2P/Sacij/ZqWZO9xLX+
         u9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789529407; x=1790134207;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2bm31ePa7WsV8qeFRceTtEGTceD7Q/MB+XojEjfCZKc=;
        b=F02n1y2byfIVNV1YatvbMpOyqYbJi6hhdAEsyuOhNyE4pSKyc0umgIFp5yauoFklOi
         eXM5qOj7qvhRyzAC0gdmmPEQmP9GGv1ZhxIDFALKx34+uT7rntmbyoLlyWR+SzPWV1xL
         lbd1JajMXBUqsDPvsQI9r4AcnSk1FjmvJsiNqkjp3lDMJPaiCA4HqpUHk0uYSVkE514Q
         nQom50iirhXJJDcFyLli0E9kKxyW0WYVXKmY1Kf5c+3w/Wf430qKSUheCRM6XIKu91bt
         xO/XCLNG8XVzmYhY4CNFWhERo0WUFvWg2B2tkybjvk06VLbuyGd2VvQfGNpiMKrpHoRc
         itDQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgjSRUyoBKcgzuyQaVho2cc7bjtlxL5U0jg96c0Us1NJlmkiASm3BnfnCljaViciKlWytbSigzgarLH6DQ@vger.kernel.org
X-Gm-Message-State: AFuF++lgZwpkay83fcU3cNln1kIbqgcxgkPS+rg7tlWRZW8ucFOSSK/w
	q29+f6FLtRrI4qBF7TRhGXOgA/Y0t0H068nQX1uvVT2ZKOyqu5P6kl6YMoZPLr1UJw==
X-Gm-Gg: AYBFou11FfkatzS9JffjGPqoTxOElzI/nSDUoAecdiGLem7C3/hcUgHb98tn+ho/nPu
	yPUpiMuDhWdy2mLKAz7LcJks0m2n0jizlN5KMKq22rGKgoo0u4F9qRDkzHsHmcL407lH9uvn1ha
	ov5ULfYWEX01Nf7LIqc3qPUDhD5dSZqBsDwxj7V6sDwX1AkF5foDqhLJGVZ7l3EnB21QthDqJ4F
	yL8HJtUQsQWnL/sUgdwEA3o1HV791oXVSWj+z0qAqRaOiDeXSv05siDEvNl7Ygol+4lDOSox1pv
	yjoy53kFEQQLonK1xa6qHowTePrMHkKSs6J/uZYXBDP3ImNC8Os2eJo3WzlM5hGBPERY9YBQkI9
	V7SnHWmcoBk1g93lxBtZFbk2HEhZ4N5L5fIR2lrbn57IiI+rAdDYnEl2J6kxZfeWyte/Vx3RvBo
	LDb7KMGKOJoJVjgpP+3GLtY2YnvzFQAp5lyYL0b1eXsS1Y3mEYfi6+PJCxUrD3BvpqH12hZ7Hf+
	4bDfpS7BYb2EVQ+W65pIf9+MKz0cSuyym+9ueEmnKSHOvFtD+M8s2K8RQWX1B9eUzwOzZQK22/R
X-Received: by 2002:ac8:6543:0:b0:530:b2e1:2f3d with SMTP id d75a77b69052e-5327f5a6abfmr16520821cf.52.1789529406632;
        Tue, 15 Sep 2026 20:30:06 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5326201c60bsm11362971cf.13.2026.09.15.20.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 20:30:05 -0700 (PDT)
Date: Tue, 15 Sep 2026 23:30:04 -0400
Message-ID: <44bb4aac4a7957bc4c2418967eaae790@paul-moore.com>
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
Subject: Re: [PATCH v3 2/2] selinux: recheck intermediate backing files on  mprotect
References: <20260829213256.51527-3-kmehltretter@gmail.com>
In-Reply-To: <20260829213256.51527-3-kmehltretter@gmail.com>

On Aug 29, 2026 Karl Mehltretter <kmehltretter@gmail.com> wrote:
> 
> mprotect() can be used to bypass the SELinux checks that mmap() performs
> against the intermediate layers of a stacked filesystem.
> 
> mmap() checks every backing layer as the request descends through the
> stack.  mprotect() only has the lowest backing file in vma->vm_file, so it
> rechecks the top-level user and the lowest mounter, but skips the mounters
> of every layer in between.  With two nested overlayfs mounts and a policy
> denying mounter_t -> middle_file_t:file { execute }, a direct
> mmap(PROT_EXEC) is denied:
> 
>   avc:  denied  { execute } for  pid=71 comm="nested_exec"
>     path="/payload" dev="overlay" ino=9
>     scontext=user_u:base_r:mounter_t
>     tcontext=user_u:object_r:middle_file_t tclass=file permissive=0
> 
> while mmap(PROT_NONE) followed by mprotect(PROT_EXEC) succeeds.
> 
> Preserve each intermediate path, mounter SID and file-description SID in
> the backing-file security blob, copying the saved entries when another
> backing layer is opened.  Allocate the array only for nested backing files,
> and release it and the path references in the backing_file_free hook.
> 
> During mprotect(), recheck fd { use } and the requested inode permissions
> for every saved mounter, and include the intermediate layers in the execmod
> checks.  Policy for nested stacking may then need to grant intermediate
> mounters what a direct mmap() already requires, and execmod on intermediate
> labels for binaries using text relocations.
> 
> Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
> SELinux policy, on a mainline tree containing
> commit f2381b546e7e ("fs: fix user path of nested backing files").
> 
> Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access checks")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> ---
>  security/selinux/hooks.c          | 141 ++++++++++++++++++++++++++----
>  security/selinux/include/objsec.h |   8 ++
>  2 files changed, 133 insertions(+), 16 deletions(-)

Merged into selinux/stable-7.3, thanks!

--
paul-moore.com
