Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C581E633C
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 13:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040701; cv=none; b=bmSJJOhsiA/g8heV0Qh0iwBSLrB1h4hOkdqcVegQ8kHSr+rm0gCHBb7kLbX9ScmzsdS3w15kwvuCo/BlwsfHJQCsWvwogCgih5BJwmSsctLboBcGT09OQP47hI3PnUBCUSWW7P3jtI5UxymGEaWwP/Wyur9EXzcUDUcN8ZtH0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040701; c=relaxed/simple;
	bh=Ax3Y9gX1ZUmbL/q+/mzj3MbH2+MCJsINuDamRAt4zMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S7TFbdkTpu/AlJMLjTi8kMjZfuOKcITklmAqzCHqusFrkWboeftn7ZSasD7APiHR3iLna+E+rI0bp6fvBmz/9QgH9a2WfmOYNS2kR5NjfTOa47fHuLOVeH1jFsRic0BwHZkMCdfNosc/+f82EYpGbWNuLaJAWE74RwyG4PS3W6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=NQXBE3Gy; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NQXBE3Gy"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b21fa7b91bso81086585a.1
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 05:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763040699; x=1763645499; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ax3Y9gX1ZUmbL/q+/mzj3MbH2+MCJsINuDamRAt4zMc=;
        b=NQXBE3GyjbeYG+FB+5iEXaf/C2FpVRQuRGEiAmTFqJGsJ6C3uspZb8znaV/gMlG9m5
         4Qedtj748xlH/OjqdgT41rfzQdqrW3oleNOBFngm4/BOmZ9JAFqL7Z6XEw8QurCL83GV
         AxZbAcdfURYSN/juYDFCdsP7R9/4wAbiI6fEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040699; x=1763645499;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ax3Y9gX1ZUmbL/q+/mzj3MbH2+MCJsINuDamRAt4zMc=;
        b=scHeGSUfT3Tn3YL26ZcfGie9i8P+0xYvknLtXBpKMx7xGDnulTvE6i3rBSCWQlF+QF
         AnuMN9+QeM85nS4UgWqG7toQET8GS0WgVzpRvYSyfVbhD7yeCwo05URFOHEC08gXwzDX
         jyB2RJ3yb1NQShyb4Q6Bhxwwr+mmxQQV3ruhcA4JDGxn5tlb1txVe/pnY0ZBfKJAHyON
         kthih7ZJ94KrImSl+NaQicqt6eWRbhCoWPhHRHlRNHrQ+HBbntzp2NiAsW48QRywka9T
         vLvHkM/u233jKyLR/lth+fotaWbulB0sU6+QANAEd0IgUeKoU+wZ0UVZA5MPTitKGvEh
         q06Q==
X-Forwarded-Encrypted: i=1; AJvYcCUXxEb3sZ0HUZihnMyAFFlMJiFpyAXIuzgmZLhJT8qT/s0TaYrXhNenZFX8/ziFeIf/5sjIvVxZHn/w8W7Y@vger.kernel.org
X-Gm-Message-State: AOJu0YxkRBQ70/3K8xALzEh8/wWhctj1JUi2PG9hKlGjbey22xWux8Nc
	akOr/5TkBR6flejbN4cKowPXmrTHvDGK8sOfmkZAXC785BnBizLKgJRsK+l7wl86NAUNyNOgF/S
	CK9XbdIxVZkHbZxPvS3yF5i/6fUtXhZquO34p8855ehq0QRFweaf84EA=
X-Gm-Gg: ASbGnctFsO6hVrcd/VdBdwtHUCkwgDsTwU5FSJxFmKLOW56msGDnZhU0E60Ajqg4lvr
	UZf6BQBS6XiwIBAyiAjoS9/9eKPTTyausdlGZoWOQE4tBv40GvVe0+583BqyjYO6DlUn5rAB2v8
	F288q1wV314Et0oRVw7QGuSa303H3FwHTtSGk7lGAQ9jlpEot0cmNK53QBRj90VFLso+kOMcGwp
	3JPC/HkPsyN4RvH2We2TiZ4O2raB/7vlOx2KQpJ7t2qbJr4CjSUV8/Tk2Nn
X-Google-Smtp-Source: AGHT+IE4l67LfIFUAoL6YMj4yvFrNq3hC+Odb67sFJq1MxiWP5V2TQHshdoS6oFGQ4ou5uOwv72kTlMOEbZ4Ve/bk7g=
X-Received: by 2002:ac8:5884:0:b0:4ed:6504:96ec with SMTP id
 d75a77b69052e-4eddbda900cmr87104421cf.54.1763040698916; Thu, 13 Nov 2025
 05:31:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org> <20251113-work-ovl-cred-guard-v1-3-fa9887f17061@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v1-3-fa9887f17061@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2025 14:31:27 +0100
X-Gm-Features: AWmQ_bmSbb3TqI3Bzf63PgWag3y9K5UzJmasfZ98WfjSXHrA36CooBlTamJElpA
Message-ID: <CAJfpegt9LQe_L=Ki0x6G+OMuNhzof3i4KAcGWGrDNDq3tBfMtA@mail.gmail.com>
Subject: Re: [PATCH RFC 03/42] ovl: port ovl_create_or_link() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Nov 2025 at 14:02, Christian Brauner <brauner@kernel.org> wrote:
>
> Use the scoped ovl cred guard.

Would it make sense to re-post the series with --ignore-space-change?

Otherwise it's basically impossible for a human to review patches
which mostly consist of indentation change.

Thanks,
Miklos
