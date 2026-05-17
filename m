Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC3535C19F
	for <linux-unionfs@vger.kernel.org>; Sun, 17 May 2026 12:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779021624; cv=none; b=GhoQrLjQDqPnBAOv9udBzdPJ897+qViB64eVivu+wJs6HCs4cyhw0uoJUrpZpwbbJqnj0qhmuweohvmOVpORWDFKUwVnVhNeGmO2CTYLFXbsZNay14kHLZ0DV+WpVSR+hxsVxwYCQY2y2ei+gT4/kSOYSd0fMDIHGK2NJrIJap0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779021624; c=relaxed/simple;
	bh=SqdcfXhNySjfZ8jeGKU6fVRD6BYJ+PAXJFdsSakJb5o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aVh7uKBDDZHKKBdsQnbmQmIMkKUz2qfpTN+RCL6JXop0a/Zqvsk/Q0Xp+f+L9pejrLH8TwnVLjYrqpi70xKJ+OnWUfkYqP9YOnKFC5UadvfW7PaNOf86d65i0PzYWg2l55GWVlk3hPC+DtL3LaN2+2fWyOf0fvRIv9ygzvTJp0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AZevd1rb; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZevd1rb"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so13005665e9.2
        for <linux-unionfs@vger.kernel.org>; Sun, 17 May 2026 05:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779021621; x=1779626421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZRYhLpPlO2XIGLy8e2lMtFFSB/FdoHcKXbU93W0aFKw=;
        b=AZevd1rbqeQr0/JN4JFmLruJCmntaJsNGFNDHF0cdMzcc8YLbJeRXBrool+xSM6NE7
         V05h1WMZxz6oEfrGZqrIoOY7ajjBS+s3G/ufl8geyg+mL4KqRsWnALvVf/04y76V0617
         AmRoMRQ/xH/0KkTJwsD+X6l6OFP/hD14mcNNKq0hyx20w0sIMFJPEdQ14e87WgkdpVwv
         ehK4GGFWrb17/BVW37PQ7W7umigop3o+wj1jIs+SVqnD2pgID+BUIyFpGmETecghVtxf
         fHPt0QwZ602vfNH5b2d35IcGVm9sbY4UFsVQZyjSv6G1Uia/++7Sb0hNKl2ZOkTGtlWm
         StHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779021621; x=1779626421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZRYhLpPlO2XIGLy8e2lMtFFSB/FdoHcKXbU93W0aFKw=;
        b=inAeDB6mnWj+dZ1ZbcIBjyw0CFxTZjOM7lggSaISDmZtF1QGNVEp6M6NmgoySDRO1U
         Y/TCu0/pJb+wC6uhSdmfVovsfM2aeayqzhg9+4h9Msu1ZlMErTrJgVLmNECyA/2U5YpP
         KQxPt03Ep1+l0jKhrW2PlHVnB2QdZCLyVaUVzRtx8btd0Ksfj0ew3fTJh0Bl8dM/REsd
         37gwhFmQOidSKoijRUah7SEYbAnsZ5ecva0R0D1aVmnavNPUcZiBGlR+sUE5Qs0l+m1Z
         AndOxiIkwT7+xg1SA4W+elZmUpwloKF/mmv3K6/VzFunN92Q/+1o54EtYqeq4LjG/hZ4
         YSZg==
X-Forwarded-Encrypted: i=1; AFNElJ9Bgh/F9XJ6S5AGX+IUvUPdzBiooAzVMgzqiW8HxrHeUSnuYa4JQiCvc5H/Bgr7K6RrSdCztktOmTK6iRI/@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9uokigoIGFan3esDoyuDoUGIDd/oazKOi/+TnmJ5nrboqRc4J
	LkjitZVUluDQNz7pbB+i7ffOHtw5ePYA4j3RuV39IpIkBK1tasggpO8o
X-Gm-Gg: Acq92OHXko4sCoYkDWjOaQ9bh57oVhrpmGs8Ag2lQ8W1XiBBb6WHdbxMjJv8drikzP1
	uEYqg+U5f+FDYjUwOvT3sm4CnHT4NKNLDVz+IIltmv2SgxD5CIOtOJO5HByYy0/wC0M2Uu4y1/Y
	UQj7nO6Z0ZSDsnytXzHKfYuDLFE4Ji70Gc4G+pVB/tqb6Vb+WjsS5iaXhY5CA5NDaCE0+slyY2y
	CRQfWJtVNFcWdeiFKMdBrWMYO0NsInlnx1QE5SVrdUKe7q9+c2i0jYvR2ceF883szL1Ct7PVCjd
	PsnXmd9Hl38WFfFIdrYClAGkUQLfgDVmlvF/dkAOMOaGhjQs+M83NKPhj8tjVZSpVQjobdr/V5d
	bdnoPk1q8R4ZCwqj8X2ENJTBjOHZylDteQ7e3nxamafKKr0PiT7HMebChE4pj9rlLrDtumaMGsM
	cHHSB5LQ5AMy0rfsYtUk3ONuEFTJy+JHmx3K9vA6+4LQ4aMN3ZnDwVWx2XuEcNKh6J
X-Received: by 2002:a05:600c:3493:b0:48f:d2fc:d042 with SMTP id 5b1f17b1804b1-48fe61f1a27mr173743315e9.13.1779021621084;
        Sun, 17 May 2026 05:40:21 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe53ab773sm201337395e9.3.2026.05.17.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 05:40:20 -0700 (PDT)
Date: Sun, 17 May 2026 13:40:18 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro
 <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <20260517134018.62901443@pumpkin>
In-Reply-To: <56380C61-04E4-403E-B721-F9B62DEA5D56@dilger.ca>
References: <20260514200129.94862-1-amir73il@gmail.com>
	<20260515193010.056ef472@pumpkin>
	<CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
	<20260516094242.77d20c92@pumpkin>
	<56380C61-04E4-403E-B721-F9B62DEA5D56@dilger.ca>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 17 May 2026 03:13:00 -0600
Andreas Dilger <adilger@dilger.ca> wrote:

> On Thu, 14 May 2026 22:01:29 +0200 Amir Goldstein <amir73il@gmail.com> wrote:
> > 
> > The check for constants may be fairly pointless.
> > One of the static checkers may already detect the obvious fubar ERR_PTR(EINVAL).    
> 
> 
> Actually, I just ran across an issue that checkpatch.pl does *not* detect
> this "obvious" case.  It complains about "return EINVAL", but does not say
> anything for cases like "return ERR_PTR(EINVAL)" or "rc = EINVAL; return rc;".
> 
> The following patch fixes checkpatch.pl to report many more such cases, and
> has very few false positives for checking common error return assignments.

Looks like there are a few too many false positives in the network stack.
Mostly because sk_err holds a positive errno.
They do all seem to be 'err = Exxx' though.

Does look more useful that some of the other things that checkpatch checks.

-- David

> 
> diff --git a/contrib/scripts/checkpatch.pl b/contrib/scripts/checkpatch.pl
> index 70c78a3..e3fdedf 100755
> --- a/contrib/scripts/checkpatch.pl
> +++ b/contrib/scripts/checkpatch.pl
> @@ -5795,11 +5795,12 @@
>   		}
>  
>  # Return of what appears to be an errno should normally be negative
> -		if ($sline =~ /\breturn(?:\s*\(+\s*|\s+)(E[A-Z]+)(?:\s*\)+\s*|\s*)[;:,]/) {
> -			my $name = $1;
> +		if (!is_userspace($realfile) &&
> +		    $sline =~ /\b(?i)(return|err =|rc =|ret =|retval =|ERR_PTR)(?-i)(?:\s*\(+\s*|\s+)(E[A-Z]+)(?:\s*\)+\s*|\s*)[;:,]/) {
> +			my $name = $2;
>  			if ($name ne 'EOF' && $name ne 'ERROR' && $name !~ /^EPOLL/) {
>  				WARN("USE_NEGATIVE_ERRNO",
> -				     "return of an errno should typically be negative (ie: return -$1)\n" . $herecurr);
> +				     "return of an errno should typically be negative (ie: $1 -$2)\n" . $herecurr);
>  	}
>  }
>  
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

