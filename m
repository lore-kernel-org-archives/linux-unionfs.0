Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B718323C8AA;
	Mon, 18 Aug 2025 09:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755508798; cv=none; b=u8xpiR/JgpW+ZNK1fE0w9CLJG6QhkcI9pa/Kfe319Yun5cZZQSBXUrtLQ3RInNYaGfm33uQlHlcHXv6C5YNOxfy73tx9dHUikl4BoXNBne6CMeFmH+RDytdrnIxvnPz6i9gQDp4BRHPrRw8gnUyOqz3qdnGVNl3gcYPWwLAsD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755508798; c=relaxed/simple;
	bh=DVs9hFNpcTWHkHIxSM1yWg5m9WmhtS1rApCKM37C8y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NypqMLFAZ6aypKsBkvQ8fx2HnXo6fpePqiVZUUG8rCSaULi1jgyng8zlA7+m/wJVX/oRjC9knfXfWXGINv40UippbJ4j10Y+FSUESygEmc/yqLMiVVRW68qjSReJrZVUz4WYnEXtWA6YLkhKuz4LJdFk+kFtR529+/n5uJJJUwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AZZi4G1z; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZZi4G1z"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6188b690517so5716698a12.1;
        Mon, 18 Aug 2025 02:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755508795; x=1756113595; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVs9hFNpcTWHkHIxSM1yWg5m9WmhtS1rApCKM37C8y8=;
        b=AZZi4G1z4nkPIJzNHVdpdjM0QUzGbqH+haOHWqliWsdztucD8w/3m4KkW9advBJSSd
         WTFMUuPESHXTH5+pDEL6pJC/V6kNDPe1FUU1pizdIw+lWu5UQLSjwNHkJiZUT47/BcfT
         avP8KlN2rHJNrFkdk0hUMl4xQZG+GcFLLlqOtL6BQnJx9eGKGopbQXgg0kY2eFb55OLR
         /6O0tmb98u8j/yoMzchYNQXMtCix3GJVytLkhvLNMH99ocREXTd1FEY405/oB8kLixN+
         hlVZp0ivDvw5K8+poiR65i4M8zkFUFsCT883LP19Qw6JOmWNJ1x6pIIWEyG9UohBPpF4
         Gd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755508795; x=1756113595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DVs9hFNpcTWHkHIxSM1yWg5m9WmhtS1rApCKM37C8y8=;
        b=D13KLRuJfaeAMBAma0cgHPRrXdWqnN5sr391be4Qd12lFhefx4+gMChK02g0NNDfGg
         ofxOZkHpJzZoqWyNH02OKh9cijXsNE9yHqAvc59ciZHmk1DsqdZE3WDkM4Nm44QGp8Ks
         i83SMOetudmSitTh1eIamiH1rHc6ifc5PzAIVgrUnQ5SEsoBhX+GQ79d/yd25XKdKnx9
         e6TIlT7S0p8DoNof+Mj095R5jK6+r8diF+fnDU/WO4MenXbl8/aLN93RRSX1rIFXbp9p
         Kt9G9NLAt+KVKFsEcx9CTZUm74QwaT7aeQ/eSdR1b+SAHmN1ym2WXXVU5Ud26QYsuK8W
         ymvA==
X-Forwarded-Encrypted: i=1; AJvYcCVMCbedfcoZd5gt9gcWBmeG39D9tILYQbUZuz7vKfELx1EyeSjUpD/o67H3PPwrsr5zgKc+fgxaNe2BDghNyQ==@vger.kernel.org, AJvYcCXJx5H7gnMMLx2+FQIfUeFUY/cpYHhjCY6QeY7jG0jzVOncUQSL8Wg0XvQ/bevT1gVQCwN0aw45Ou478eokTQ==@vger.kernel.org, AJvYcCXgQxLH4dQGaCk87NUkVAAVWvWTebYAdB32Up0V1yboBpl4KVhhRHATqUPo8Fi+8Un28zX9irCe4c6e/jiJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyV+iU7GaPAALEo/G/8kBqVQ+4RsFgL6AUoH5/74HOLK9celsYr
	fcrSE0yqpIlUWOreSWBETHtDmwHLwTZkR9PjiWBIhjq7GRnSbuovPY+AuKRTD2w59+aydl+LmC1
	ItPuu55hZ+Kn9uTwQ56pkFONrrKc9Z7Q=
X-Gm-Gg: ASbGncutj439wbqP63lO1DOxjWK1mT70IE/vwmmDxuakr/djMPkPp/baPTNOg7yKMv7
	iPwdaCCz5qhw8B5oJtdWoj5uEA5scLBwrBaypMC6Oi0tDo4n1rTPvjxel9e0rQHSqekrSMzvlQ/
	r13G3mpKZ8Ln4Ll8GgGd6j5QCSGZLERGsg4fMGWUrjuHbj/0FaVCQ7/2UzNxJUbnqYGSxDFlhU5
	oHhNkY=
X-Google-Smtp-Source: AGHT+IH0aztkcb5sHyiRcLM2P6WEW6yXd1DAccaUtVR/nCnyudWpV2r5KuSMly5hj/2Qd/kcRPm+Errd4vE140MDSms=
X-Received: by 2002:a05:6402:21d7:b0:618:4ab5:e85c with SMTP id
 4fb4d7f45d1cf-618b075c65emr10422064a12.34.1755508794688; Mon, 18 Aug 2025
 02:19:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67a72070.050a0220.3d72c.0022.GAE@google.com> <2F4A26BA-821F-4916-A8F6-71EDBA89A701@gmail.com>
 <20250804032312.GX222315@ZenIV>
In-Reply-To: <20250804032312.GX222315@ZenIV>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 Aug 2025 11:19:43 +0200
X-Gm-Features: Ac12FXz6AI1I5HtZbroUqak6oNzZh98h-NvBhOTZHkRCFkiibg6Lf68hm_RiZKc
Message-ID: <CAOQ4uxiPPb70mx0Pr4Ph6hw2j63Q8=PZaxBx3N0KP=d7Ko=1KQ@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_symlink
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Huang <mmpgouride@gmail.com>, 
	syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 4, 2025 at 5:23=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> wr=
ote:
>
> On Mon, Aug 04, 2025 at 11:02:54AM +0800, Alan Huang wrote:
> > +cc overlayfs
>
> Sigh...
>
> 1) ovl_copy_up_workdir() should lock wdir with I_MUTEX_PARENT, same
> as filename_create().

#syz test: https://github.com/amir73il/linux ovl-fixes
