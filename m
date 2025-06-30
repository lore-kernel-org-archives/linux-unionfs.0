Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0846525CC57
	for <linux-unionfs@vger.kernel.org>; Mon, 30 Jun 2025 11:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751283225; cv=none; b=N3lwdkHll8MdGASOJt+Mf/0DS58xL2b0s5kEep+nQTrL2ed1vBiICRlkyZas5mw+G3Z+J+GZ6SKH89xz/ANEMciJd7p0Q8z3eeQqCZhK5U+a+bl+paVdoBz5ZtFrHY+POghJwwb/IiXa0XUIUpAeBV4q2MIWDF/vIXrnhrZ2Vsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751283225; c=relaxed/simple;
	bh=07uvHHlnHh0VVlz+DTGdO0oIjOnV9WfuBssw90x/cmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1WaFApy0dhItxik3J3n7kUuWLwTC18k7sizPTJZfJBPyS9Z5HEUq5DM9gYHdzQlavkbOVM3s5OiFhahXeNseY0umOUlO4Uub5QWUxxVUgNeD779RqIA+h3oxYcbVrLDGpIsOlkQoCxJdHsHwHn7ZQnLgK5RL8vu2dHU0G1nMY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=X/PNxRlw; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="X/PNxRlw"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7d09f11657cso388752685a.0
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Jun 2025 04:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1751283222; x=1751888022; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tus3vRMIGbFaFYmjva5uehJWq4zAy8HIVgAKqkn9hyU=;
        b=X/PNxRlw+BPPT66c+eE0je+x1TF5uIfAcJgJmoghc5walIca25O564PA5NozUc1qmJ
         yAyys6FiNL5XYjN8xj1aqggKK7VckoNZZLCnTLdKx4+ANDvoU/j631L0g6yKz74cyzRW
         Juj+5M4eDzsgluC/digkuAD3Tp9yFim9k4cDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751283222; x=1751888022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tus3vRMIGbFaFYmjva5uehJWq4zAy8HIVgAKqkn9hyU=;
        b=swOMnVtIDOOLtv3W9I3Xygg+vsqADvbNL8iAbHng84NkfC3jmoPKlVXJy3wiUx+PVc
         Pxge4QLO5X75WwnSsT+EX96tMdcaLMUQBc6wnEFd3RuJ/UuUFEekYzzyIyDXyq8Vt9rv
         bEexFB5lryb7z1vvAYj2Ep7+h1OvRH/R6dlIsTuVLzuK1UTb7e2KNtdEK6mXZTibvSpu
         Qf0t2nHc2ak9MioibWWkrOiO+SVXOKi1642dYMT62FdKlayir4xk7JvLljiWY4kzK+rz
         jNVItbF+2pXrxOrS0oG9Zj5XEcrgYHw65CAoZ3MKFiClxcCAiwSJ1tyCOfB0VfRmWQkR
         dv3A==
X-Forwarded-Encrypted: i=1; AJvYcCUUNQukZ2xpi98OSAa6dnXmY3z2JgucHSWoAxwZK27LjpJj359TD4v6hj7ufhLUYZZK/yhhFsshB03OhwRR@vger.kernel.org
X-Gm-Message-State: AOJu0YyNOKJkiEJa6kGrJ5pcLcfatioyYDt7LDpd0Hz855kKQAJTxlM2
	JlQi4Wnr8Ytdvoc2iNek73PzI/KuRpGmvICFJu3z5LwjNb94Er4ombYfswPkHBoQSwtBlA7Layj
	75d2Ya5tjssshptl2519NIQYq1qjhI9Pim7ZZQ/EPF95B6SBfhvHMUpo=
X-Gm-Gg: ASbGncuVpevhhERD7d2mD58H3ur+2zaMKJMSSrnr/bWDdibHl5+mlrASgmndO9TpHW2
	PYKF3tckkW8+LqjyKzpBgYMw3Db0t9GjwiTcupMXdtj+9Ox+7nmPyfV/S0jT7Me1f4l3V+d8B9T
	zfTRE45wRt9gG4QhWYM2lW0+4iYO12573KfFpRugI3BfGWK4GdQ4DerkMQXr45d5U1SH9BpjG7C
	RBwbLfvy7sDzQY=
X-Google-Smtp-Source: AGHT+IH9S55JU/IjYeFl/Z9WS+ibedaf/OWKjQe36UGqm71pSeJDJpYTI0bR1VDPa8cUCW+zm0MzMiI9xe4hyKaQPzY=
X-Received: by 2002:a05:622a:58c8:b0:4a6:c5ee:6ced with SMTP id
 d75a77b69052e-4a7fc9d5233mr236155911cf.4.1751283221667; Mon, 30 Jun 2025
 04:33:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602171702.1941891-1-amir73il@gmail.com>
In-Reply-To: <20250602171702.1941891-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Jun 2025 13:33:30 +0200
X-Gm-Features: Ac12FXxsltcku95DZYoyPdjCaYcmBLG80SjGKx7yduWUYQ-n3cbod1rF4rohhpw
Message-ID: <CAJfpegsx8to=HK7Cu5_9hrgTddrROSSOuCU=cSkhBs_5On33OA@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: support layers on case-folding capable filesystems
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Jun 2025 at 19:17, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Case folding is often applied to subtrees and not on an entire
> filesystem.
>
> Disallowing layers from filesystems that support case folding is over
> limiting.
>
> Replace the rule that case-folding capable are not allowed as layers
> with a rule that case folded directories are not allowed in a merged
> directory stack.
>
> Should case folding be enabled on an underlying directory while
> overlayfs is mounted the outcome is generally undefined.
>
> Specifically in ovl_lookup(), we check the base underlying directory
> and fail with -ESTALE and write a warning to kmsg if an underlying
> directory case folding is enabled.
>
> Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
> Link: https://lore.kernel.org/linux-fsdevel/20250520051600.1903319-1-kent.overstreet@linux.dev/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Looks good.  Thanks for taking care of this.

The only think I don't like is the pr_warn_ratelimited().  I totally
understand why you did it, and I'd love to have generic infrastructure
for returning extra error info without spamming dmesg.   Oh well.

Thanks,
Miklos
