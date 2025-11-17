Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FAE25F98A
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 10:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763375420; cv=none; b=oqCBiGy/itweQ+AwgdyfrrADo2uQdapdquAohkax4zLwEaqUQ9EVHsvizmX9QHvFzQXZWL+6A2vT5m6ZyQm1N76QicZetm8GdAmUHEgk7LjsdWhB5GluVMWnj5ChK5R0OoytVIDjG+TBjVbROqZkjmh5b4wTY1r3BDTObpDXBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763375420; c=relaxed/simple;
	bh=uDCCQXzcWKHDdw6+FUnhEhT/EnEM+9jDsx38khAZyt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aQgnt+QQ2yecuNI2wh8npgsLcek7QnJliER82xaH8/IWlz7JjR54Fgd14//srkxq2dUY2wurw/aEXzNYnjOCbNykyWmkeoyz+hyW0nbyGl2tEbsNKk6XgYqyO5Kn92VmWkMIdb7rRsoVvq9EeInrbfcnxwoI8z9iysDyeAg3Onk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YlW0EMnh; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YlW0EMnh"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b727f452fffso847896366b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 02:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763375416; x=1763980216; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ghXYPE/gMEzITHPum2kYyeM5dHW4Nj/tBMdJSh+GKnc=;
        b=YlW0EMnhOziFpGjQAD97RkWmScG7BMRkkGsGc7YR+cCepvcyxg2A5y+qzBujQwumXU
         zl8Zp9FfImtchdcikNdAFO3bOeX8kbXG3SrA0PyLRAMyqc/XehYwM90MpEJsEMTATnn7
         erY2+h2+GYy8HjcqQEBppGSmOVSWNUJjk5pXc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763375416; x=1763980216;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghXYPE/gMEzITHPum2kYyeM5dHW4Nj/tBMdJSh+GKnc=;
        b=FMHcTyUXao3oIqC75aak6ZOGaWrA0AzD4+VhyPWdgoMluLQyt8fSmkpdKPVZkjrNQK
         XzkDM4JnCr1v3YYgaGb9Ee/uvIAK9T56BlNAZuV4pJnYRfzff8KvT3WRD09yjV4A2bVX
         6t/elAf3jzx5p62fIHNhIrQWPmdNXpeuSQlTRQBXgvVpnAz/Aa0ihlYE7ePFCDUak3Nv
         Y6SUiTK54sBiRLPHBhFxiR5AzmOyrxrpBNruzfsKfU2ck8jVdDtHBOOi13tf30R0cLIh
         p+B390kHP7hKK2LprxrdJrCwjdEzsE0X7MB4ujF4JzEB/KCOPhjX4ghgSrKRt7gN67vQ
         u9zA==
X-Forwarded-Encrypted: i=1; AJvYcCUurH0PeWEURoEr0UUL0RkbwCL+ChijEuyenDNALLZPIJRvXySLQ/UCCiV/iCn0eF83xPybnaYQG8q+n8h+@vger.kernel.org
X-Gm-Message-State: AOJu0YzfgK++RK468Hu1EmmNmgMktVflJsQOfyRfCJuMQMvb5b1hkR3L
	5UIXsWx4V8UwDRlo9gkEI1KvGIiCy1rNIl0uSMGVLddZ10thb3+lQNKyhn93gBVfWz5KfHk6OhF
	44e2OqdU=
X-Gm-Gg: ASbGncvRQmHJM7wd3c3oUNYvLwYF3fFRWRnLLlQebJVH4QLHU0usQXvuaVJxyUyT/p/
	ZMRx1wQgcCuLQ1BMtNYe7aNUM3ucRT8I7lE9Wy6LVlIm2gHaGLrbCC/T34G6N3BbBbvPJXNKA/o
	IB3qLh4QNXSMZ96d0ykDoxIjApbr3hRP9N7Yr1xkr5zPB7VGefXSaWn2x+S5EQKlhVaVffswntn
	+epj9jKPNnpIjRaVd0jO6eplldwe6EKucza6Z8+uNChAG+MEBgj85+6n5VYB+KNTl6Z8A5GIdpn
	Ntq7DCX79grmlNug4D3rs8uK3S6zE/7+GlCOzznfn7ENy6Vo+XpZ3l3fMRRhHyfE2fbFvA2ofRl
	ceErU6m8nWYxV48q0iC7MOgQTGQcGL7f3gUD4Ekxarv8waME5nPhP/bqWI5eixxTdwsUmxL+va+
	ns8wETWrb2GtScnDI1lMXkSqNG4IzcJIctR5+zWA7xuwkjynLc+A==
X-Google-Smtp-Source: AGHT+IFoAzxwFaLT+DHUUXuhZ6PDOpTjbdnqqAWsVvJVCG93ecTbs5yiVovgOqgqjwZCaayIxpufzg==
X-Received: by 2002:a17:907:844:b0:b71:ea7c:e501 with SMTP id a640c23a62f3a-b736574c6d7mr1446619166b.4.1763375416512;
        Mon, 17 Nov 2025 02:30:16 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fda8a7bsm1024202566b.54.2025.11.17.02.30.15
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 02:30:15 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64165cd689eso8034507a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 02:30:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWxPqBNbr1o9pG0qvKYR4FtiaXVmvpTGuCY6Nt9TVUX+ixxHASXBST3/CMqZqQTK1F9Wy+NiG+7GimOSWKA@vger.kernel.org
X-Received: by 2002:aa7:d8da:0:b0:643:130b:c615 with SMTP id
 4fb4d7f45d1cf-64334c7e125mr10982774a12.6.1763375414716; Mon, 17 Nov 2025
 02:30:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117-work-ovl-cred-guard-v4-0-b31603935724@kernel.org> <20251117-work-ovl-cred-guard-v4-35-b31603935724@kernel.org>
In-Reply-To: <20251117-work-ovl-cred-guard-v4-35-b31603935724@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Nov 2025 02:29:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=whrCSbimz8jDhh+q8AJH2Ut9V3dgyLxVotn3WLCTyoN4g@mail.gmail.com>
X-Gm-Features: AWmQ_bnwhUgEdQVd21k4V-Ihe66DJElQUz0jrc4qSGDc6kLcbscsjeq-o69GauQ
Message-ID: <CAHk-=whrCSbimz8jDhh+q8AJH2Ut9V3dgyLxVotn3WLCTyoN4g@mail.gmail.com>
Subject: Re: [PATCH v4 35/42] ovl: port ovl_rename() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Does this old "goto out" make any sense any more:

On Mon, 17 Nov 2025 at 01:34, Christian Brauner <brauner@kernel.org> wrote:
>
> @@ -1337,11 +1336,9 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
>         if (err)
>                 goto out;
>
> -       old_cred = ovl_override_creds(old->d_sb);
> -
> +       with_ovl_creds(old->d_sb)
>                 err = ovl_rename_upper(&ovlrd, &list);
>
> -       ovl_revert_creds(old_cred);
>         ovl_rename_end(&ovlrd);
>  out:
>         dput(ovlrd.new_upper);

when it all could just be

        if (!err) {
                with_ovl_creds(old->d_sb)
                        err = ovl_rename_upper(&ovlrd, &list);
                ovl_rename_end(&ovlrd);
        }

and no "goto out" any more?

In fact, I think that "goto out" could possibly have already been done
as part of the previous patch ("refactor ovl_rename"), but after this
one the thing it jumps over is just _really_ trivial.

Hmm?

              Linus

                Linus
