Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B0026ED3B
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Dec 2025 08:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764924627; cv=none; b=gYAwV6ghQypuszgXDB29/JP3I8VbOn/+Lhck5fcKAkDsoBI25abzVJqhEAM/w6V9MeZPj6yLl94LwQpmawx8h+JXkpEFy58yT2DD+xhWz4NpffPI3AVJ7l32qqNBdpOUIAhWMwEhpyvUe8NHfC9IrUUc83T2spzsI0vb5Yb7ssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764924627; c=relaxed/simple;
	bh=umtlRGx5EL/Darbl/2rxiYcpP31JcGWYNq7tr1JvXJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MAmE/jUwbvYfuNclaX9vIuVUAAGwWIgks9IZC4mOCOiIydUSPFxnxDcXtRsvDqY6e9jVwEM3EZJ8lDuaAytsmI355XmZe8ZNgoE2Dy92+RoI/1DMOjK7GJHXNKsFFkfF42+Po43BXmtLWZCS2PF43bOXl4jMP31fyHOvC3Ya7kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FXGhDwqb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n2gQ5eBN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FXGhDwqb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n2gQ5eBN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764924617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mu4vhDBoG/9WX9EFo4RIO76XRCI3bL/HXhvs+9OJge4=;
	b=FXGhDwqbHgkVCI+EIgbSmws/dt0B9NEncLkdFjsCtDgcubJEQ/NDtWcoaAwHhIe40eq/Vq
	vQwi6s5JZtfwSuL2XV3MdISY8LRCHqEDa4HURisxS1jpCkNH/sia4mO4Wc8ULRto2EezaG
	6kRSMTu9cMdWFpNe/UWr+9n92eoilsw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-vCqIvGzPNFOTsewWTJXpcA-1; Fri, 05 Dec 2025 03:50:16 -0500
X-MC-Unique: vCqIvGzPNFOTsewWTJXpcA-1
X-Mimecast-MFC-AGG-ID: vCqIvGzPNFOTsewWTJXpcA_1764924615
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-343823be748so1948657a91.0
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Dec 2025 00:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764924615; x=1765529415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mu4vhDBoG/9WX9EFo4RIO76XRCI3bL/HXhvs+9OJge4=;
        b=n2gQ5eBNROTJphP3Uc9b/wJikltdttBENQvvHaf0iaYKWq57ft8/oQdE0Aih9lbKT7
         BSNAi2+uOxXZ1kWGdlIbwM3u7KC+XWvyh74pUUjPW+pseQPpLucuh4UbF8xOGoQ+KFFy
         4NrGfVrK0FQSuEAOSSkOJXYN7qO9++cA48b6Wg/VMHqU+9ndni29sKvSX5ihuKCsrCIo
         X7NvVdJ+I+s4bRHS/njGQPBTUdW+/uxKOxshyP5MltVjo9aaUlCELhi3R/CIPh7Q7fH5
         TJ0F7kU+5QjnCRxkOlHAqIwrRJ277WJX3BaXnmNZXQFFDz8LtTU6vDhfqd1PSgb3vrG5
         bEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764924615; x=1765529415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mu4vhDBoG/9WX9EFo4RIO76XRCI3bL/HXhvs+9OJge4=;
        b=S2fQggUMS7uhPrvNs5YkGNQHm3aViVf+GH2CuXv8Qw155xZA9wRSq93MTuOuu+HIws
         yxMxuzyL3DM/+/xvoAqMFpv4Bl7rI9JrfI6t5JeJtKhwwtgvcF+anekkZ2lrFR9VB3xG
         wgW9DqxxfyqitCGd4Rrc68bi1No+GH0eb8B5hXh6PtScU2iwoYQsKJgPeMM73zlneRWS
         gRVliACbPKG/qoKxvvRK6fD0wjH0Xf26GRYttl8PT/6OLAH2V3gdh1LZilH1WpagLADW
         mFfaJAYFm4c5m/x1/V22aKxY6elBHdRntorfYTDTQPVgE3weEQT3OHMf8MpYRdhW3zOW
         VYkQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0LanRGr5riPW3FYFE5+I8m74fmGqD4dNm/MIgl1+DYxEWXFV3k5Up6PgJuBhwEzrrKhnf5QYeVFY/3bPa@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8jbNyojJPGD+w6bxHMoCOsj/+oFzLPUofKriDd+aXyyADoDei
	PoJaJV+XSuLeQnr614o7b2X97Mu0t7+732WRadqOg33xQYvoNtR4BCCSgR1/0RUj/HVcfaYvlFo
	vIfsneH4RRskjtOlr/XkpgfDFrh9C5YCX21CuvHulZM1366en8Xqh79+X2ll/Tp795iFYLDaTpW
	3IUGxsCmee2pzq5L2OkRET/VmpsKYALKW5JKhFz0K7tg==
X-Gm-Gg: ASbGnctV1xMyqqhSStTwT5ENH8ccDe/72B8WJlkEi534JYoF0lEIHhFdyVuk/u1PkTh
	AloYbdi6YOgvwG1JiNEjRrgzpkk6vkqKXL4gMyDXdyweAOC7Yo0H+484k2BjmIRPKX95xsvec+Y
	FJ9SAYF86tN6iOsTQ7AnHxmf+rLM/kgl77NDgN9h8g3RINhuNE2+DXOWqvsvW5as7M9Z691D9jA
	ZS2ufyyx1WXuD8lv6urCDnttKE=
X-Received: by 2002:a17:90b:5101:b0:349:7f0a:381b with SMTP id 98e67ed59e1d1-3497f0a38cfmr722886a91.8.1764924615505;
        Fri, 05 Dec 2025 00:50:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxpl8nhnsm5A0Jf0tNdztoBLeKfKGGFhMtxDcEJNxWg5wU0TFBdOzIF/jbehPxHYjViqqf2YHleDsPoD3CxZ0=
X-Received: by 2002:a17:90b:5101:b0:349:7f0a:381b with SMTP id
 98e67ed59e1d1-3497f0a38cfmr722869a91.8.1764924615172; Fri, 05 Dec 2025
 00:50:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHC9VhSaM6Hkbe+VHpRXir9OJd1=S=e1BB3zLkSTD+CXwXaqHg@mail.gmail.com>
In-Reply-To: <CAHC9VhSaM6Hkbe+VHpRXir9OJd1=S=e1BB3zLkSTD+CXwXaqHg@mail.gmail.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Fri, 5 Dec 2025 09:50:04 +0100
X-Gm-Features: AWmQ_bkqx9hXWJfAa0OD0GP1AsTD2CoA7wXj3vHVaodmsfNKvjiCR2RIZwD1OvY
Message-ID: <CAFqZXNvL1ciLXMhHrnoyBmQu1PAApH41LkSWEhrcvzAAbFij8Q@mail.gmail.com>
Subject: Re: overlayfs test failures on kernels post v6.18
To: Paul Moore <paul@paul-moore.com>
Cc: selinux@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 12:46=E2=80=AFAM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> Those of you running tests on kernels during the merge window may have
> noticed overlayfs test failures in the selinux-testsuite.  I just took
> a quick look and the failure is occurring in test function sub_42() in
> tests/overlay/test.  That particular test is expecting a file type of
> "test_overlay_transition_files_t" but the actual file type is
> "test_overlay_files_rwx_t".
>
> I only had a few minutes to look at it just now, but there were a
> *lot* of overlayfs patches sent up to Linus for this merge window,
> most of them relating to overlayfs credentials (moving to scoped
> guards), so it is possible there are other SELinux/overlayfs failures
> as well.  Has anyone else noticed any odd SELinux/overlayfs bugs in
> recent kernels?

Didn't notice any other recent bug except the newly failing testsuite
test, but I managed to bisect that to:

commit e566bff963220ba0f740da42d46dd55c34ef745e
Author: Christian Brauner <brauner@kernel.org>
Date:   Mon Nov 17 10:34:42 2025 +0100

   ovl: port ovl_create_or_link() to new ovl_override_creator_creds
cleanup guard

I can't see anything obviously wrong with that commit, though. Perhaps
the author/maintainers will be able to spot the bug.

SELinux testsuite can be found here:
https://github.com/SELinuxProject/selinux-testsuite/

--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

