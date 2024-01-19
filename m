Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FCB54BE3
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Jan 2024 20:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705696215; cv=none; b=Fv1s5r0tnByUB7BhFczozO8FVEDY6eeDT8uASqzFwY4H07ShdGkifKJEmNAsSubklk4aFJUr4WTvHqas9R7OfZfw7rY0+N/amXo5xvtP2rXmimCWMnZW6FyxTX8+FUcXVBYu7MLbSioa6+4xlIpwpl9ItDUulQEO/Tx/aAj6IaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705696215; c=relaxed/simple;
	bh=8OYZqPISIFN5KLjECVoHCt1uNlCy0BijTW360W4wa40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtTh1w6Rfo5MRLYo0NvkBnKcGG9C6IiK4dxforl/xnlcuO8pgEp7NEd8/49ZCkOuo/rigztejiw1gGrRr7K92C1hrxrtGFIgC8lxe48zJrStMxPnqFgI7OVo8G7mllR9MFYtHQKvsb1FwwTBKgzvrqB8/G3ve1QkcQ0M7at+Ee4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=VhQWwBY+; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="VhQWwBY+"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a28da6285c1so227449666b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Jan 2024 12:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1705696211; x=1706301011; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uDGXTncqm9MB3BL9Zt8G5ddcs+43LzaU9pS4N/bFZaw=;
        b=VhQWwBY+pdHZlWirKg0fqls4o1bwQvRHX+CK8OX7R8Kby4h2cFtIfTPohDR/ZO1+/J
         kv0bCHdgSLWHUMQdqG95IdOcCQJ7wx17N8vbvkIxVBgfKnzLEzelTWw1CPfskU9MiZ1C
         V0EPi9GmWu3vvnwxCO7QQ3yBe8qNGhR8IZWNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705696211; x=1706301011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDGXTncqm9MB3BL9Zt8G5ddcs+43LzaU9pS4N/bFZaw=;
        b=NjdvKi1dKu4saCmAEyws6dmDfA0P9B0ikQ9wWky2JaY9PZFFrL86BbvHeA0982WvHU
         b1kZB212YoIdFVZJIulAXRe7B+V7NAHmQ8mcI/sai3ckAYldB+bbAuGGEowPIqsvw5o6
         +ShLd7HPldV+J2ByoBpv+HtfizFmFSC/6MNE/w2KXfjq1d26SvIFHJKwT8KuTBtDc8H9
         2n6tg8imt1L6F6L6fzQnenlPfYCp8eSswibhHoebtFJExTRw54eByby5IOW8QsKPVBQZ
         FO4qateA1c+itdFvt3F+66Q6lAuoef7Fc5gHjXps0rqujgnAE9s8Ofbb9VRyULFB60Rx
         qlBg==
X-Gm-Message-State: AOJu0Yx2LkaOB3YCvmZ9012rfYuINNYTtU2GMiACSSzlHn2A0Xrs91J9
	//zLsDh+vBVHTx257GwfBzVzK/rzN9KHAlNrY9cuD+djQYouEQOXKkoRTQPyIIT8T7dG95MlkbX
	kgv+D7GWk23zeVU9QXY42C6zAkbuSO2GUMP1kkw==
X-Google-Smtp-Source: AGHT+IEAii7Y/IUup/E21nLLKZG3h7YMWqAccABZoHNHDmiuXaqhXigJUCgpyKgYEXNLdxgQ8bTu70xR/vO2hJ2VpyM=
X-Received: by 2002:a17:906:714f:b0:a23:62fd:e2f6 with SMTP id
 z15-20020a170906714f00b00a2362fde2f6mr445811ejj.30.1705696210888; Fri, 19 Jan
 2024 12:30:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240119101454.532809-1-mszeredi@redhat.com> <CAOQ4uxiWtdgCQ+kBJemAYbwNR46ogP7DhjD29cqAw0qqLvQn4A@mail.gmail.com>
 <5ee3a210f8f4fc89cb750b3d1a378a0ff0187c9f.camel@redhat.com> <CAOQ4uxiob0t4YDpEZ4urfro=NrXF+FH_Bvt9DbD1cHbJAWf88A@mail.gmail.com>
In-Reply-To: <CAOQ4uxiob0t4YDpEZ4urfro=NrXF+FH_Bvt9DbD1cHbJAWf88A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Jan 2024 21:29:59 +0100
Message-ID: <CAJfpeguFY8KX9kXPBgz5imVTV4A0R+aqS_SRiwdoPXPqR_B_xg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: require xwhiteout feature flag on layer roots
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jan 2024 at 20:06, Amir Goldstein <amir73il@gmail.com> wrote:

> How about checking xwhiteouts xattrs along with impure and
> origin xattrs in ovl_get_inode()?
>
> Then there will be no overhead in readdir and no need for
> marking the layer root?
>
> Miklos, would that be acceptable?

It's certainly a good idea, but doesn't really address my worry.  The
minor performance impact is not what bothers me most.  It's the fact
that in the common case the result of these calls are discarded.
That's just plain ugly, IMO.

My preferred alternative would be a mount option.  Amir, Alex, would
you both be okay with that?

Thanks,
Miklos
