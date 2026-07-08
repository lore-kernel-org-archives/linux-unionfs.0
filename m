Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852423A960F
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 19:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783539915; cv=pass; b=kDFLaP9O7FPVKp+/xIaBgVJX6y05CjhGQPT5IaCBkp8e+ekNBlX/F/srlvxpjNnqISXAlzLAN7jU5pQlkRcbboDyfF8zfvFUoW6fC7fCXmA37OJJedEs7IPy+ti27zlU1WXsWZOOJaltRdHQ4A9B3y6DICJg9srMqM3Fp8cyv/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783539915; c=relaxed/simple;
	bh=JaB8MKARUyOluTUTKfGfO9Fwrtc8Ku2njk8Dxn08suU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VgWL0fsEDCi/ObISlT68aAqHFywk6m/99gJsYQeh0YHqkyoj3apbVKmyrwQ+HFmBV8HP+J8fj1GfjZrkf2DiXZfTG5zcXDzw+DoLIRJUGr/a8IY1IJ2Ay92SebQT98Dgh17r8QyairQCAgLKML6zwg94UzD+kpnDh5M9UgYidk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=LW6ZqAC4; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LW6ZqAC4"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51bfe810293so5489761cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 12:45:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783539912; cv=none;
        d=google.com; s=arc-20260327;
        b=PdxI/49kfCxBFQTz23U/GKb6JDsiG9dLZznilsi+5LvD0kp7qaxxbFNoJ8u8sRzPW6
         Ff+LGzIxwPyCMWuBDX+dD0LC67Yl77rY49vtmHSAnGU91XzHrcNT1t84bchJwXIM9Tfb
         GISxS4dW0acMfVaDGIC+XLp9z0yiGKAZCtokD1WDgVc1Z3w06rmj4Goa8f6MVl9GvNYf
         6PWy3BECaCFte/W/Ru8XuikfO3Tnrpzz8ZoBEF4aoj6mfRlkQjtciFXmwqs3LRhVFP86
         4JDWaKdfm+bmS7OM6r1xOQQEj+26QBO13/dCegXH49XmglOpbAXPhiX3gdzfk9O8OH9f
         zjdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BRAVl1LUxqDgkvoB9BijEMJL+fVxc4zMfLM5kk+MyrU=;
        fh=sPe/eK/A+ebhTB4m7Mepcs4ZeppaAx7D0fyCTM6sQjQ=;
        b=N75l6cbStfHQpDtCc9AmAh6voj44maQ23YohdaUiuPBSr3Cz07+T+t+0Hr59afUqoL
         wi6H6J4xdG97C0MM3oq4syb2+tYu3dVFuvkIC3oVx62JZZMmbRQJO6tJ5z02ZIowavSh
         ed7DprfBP4EmtbOMjgHK5HggbKNpvB2tfmIzOy+B+gxg0OONgnFePd+JdfevBc2nmgm/
         nRuEx2wUt6d0Y6yQrZTlI9aYs3eEmkb8O8Zrm1P3FkZoIYqGSvznDdBYnQBv8+VSbugY
         0q8YuL8S0b3zCC3YdG9Ep9lEahWMK1T5OJQmF3abBy1CUlY9e9ifcgej5tEUDZTAPNL1
         uWsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783539912; x=1784144712; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BRAVl1LUxqDgkvoB9BijEMJL+fVxc4zMfLM5kk+MyrU=;
        b=LW6ZqAC4FbxbBm8HLLrTFWWlXoMUJ9CUp2FdEycrQL1F9NefHq0xM2Dq9eWhVKBmjh
         JHlkEl3qhrEXAXf46hGh6OVto2prj6QX52fAtlIl8quaqYYWRzrpiCxZOloGEaHqXIQR
         G9sgax2w4irmb4tkY2CyHmQKLbv6l+q/VWoL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783539912; x=1784144712;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BRAVl1LUxqDgkvoB9BijEMJL+fVxc4zMfLM5kk+MyrU=;
        b=TwWpk8wiEgJ1r+nTTejSbgYF/ahElX9+Bsw6b8hyUpX9OvwhyZkK2tmjB1gDoMckNe
         BfXVeIJ+kwPk3AXNSoRDTf0qiK5gPbagI88ag/VY+4PUQAMlVZWF2NF0Mt6qmAArnRqy
         KGmr5B7w+85VM6H6sWt4gaSqlY4O/VPQ0gWiisz+eL4NjW9ihi10cMyj72+WMiBB5I9x
         LZ1yJ66zwT03Lo0EtYf8CiYeT3JeBo1gDm6GpP752BXCzsvx50HfSSpxHFoC/ZJdy/rn
         NnxiLniV7IDFLgNS1QpkwtP+Z5S6+HsDyD9UPg2XDt0b47CAhLoG0w4QDVPlvoHb0yP3
         MRBg==
X-Gm-Message-State: AOJu0Yz6qcT6iuTd/dKVmMqaHdyIKhI3VH90o1in48L6ovi4GhgeIzdo
	kGz0qAcfoHHrhSxVA0oyYid8ay5T7Z2hCJmc4J6PSL6Jq8aXGe7NZ9evqDKGT44jMstaa2KmVWg
	UT0MaaAHdmbaOsHGIDDfonAi1bHgG8aLDiwxJvmnFAw==
X-Gm-Gg: AfdE7cnnZAX7pME5xtV9n2z/bDiRY9efpcTB+uFXue5pQ5L3uZXiahkahNRwrv4Qlyj
	bfzrB2ieRCCigQxtelh74k3vpXZ3E7gak4pvWH4kLbS1li94EKE8JXkSEtR7Y0VIK1iHyi8nN5G
	leb2LoqBUrlQ+jWGTtvgiBwgfBiFOoJALFJZPMWRXqO0jjqikJGZGJmponC3r7NoQCKWoxSGsEY
	fDTD3lfWf0HpTK51ChSuoVpP5xB6c32ARUzIIWQWHJqjpP3E7SGauN2L3RdAo02T4LYfa6871bA
	lyiPHGi9sL27MvKXpypPc8n50FxbCxg+pqMrAw==
X-Received: by 2002:a05:622a:2282:b0:51c:4eb:b586 with SMTP id
 d75a77b69052e-51c8b2bcca6mr44081721cf.3.1783539912501; Wed, 08 Jul 2026
 12:45:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com> <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
 <87wlv57dt1.fsf@redhat.com> <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
 <87o6gh79yi.fsf@redhat.com>
In-Reply-To: <87o6gh79yi.fsf@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 8 Jul 2026 21:45:01 +0200
X-Gm-Features: AVVi8CfEBqDFsxEsCKynN2toUTD0jqsYUgCkXMmD75nSowC3aB39c38nRzYyz0U
Message-ID: <CAJfpegvUEEbFnCa1N9k3gMXpw46YFpWuta=G6brON1=xU36bgw@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Jul 2026 at 17:55, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> writes:
>
> > On Wed, 8 Jul 2026 at 16:32, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >
> >> Amir suggested to add that functionality when I've asked for some
> >> feedback before sending the patch here.  I am fine to drop it if this is
> >> the consensus although I see its utility from user space.
> >
> > How about a completely different interface:
> >
> > int get_fd_opt(const char *name, unsigned int index, unsigned int flags);
> >
> > Enumerating layers would be as easy as passing an index stating from
> > zero and stopping when -ERANGE is received.
> >
> > It would work for all filesystems that use files as options.  No more
> > fs specific ioctls.
>
> Is a new syscall really justified for such a narrow use case?

That's the reason I advocate pseudo fs based solutions.  Let's see, we
had a proposal to use openat(), something. like:

openat(base_fd, "mount/options/lowerdir+/0", O_ALT | O_PATH);

Meaning that O_ALT switches to an alternative/meta namespace that is
based on the given fd and in that meta namespace the tree under mount/
represents the attributes of the mount that base_fd is on.

See this post from Linus as well:

  https://lore.kernel.org/all/CAHk-=wjzLmMRf=QG-n+1HnxWCx4KTQn9+OhVvUSJ=ZCQd6Y1WA@mail.gmail.com/

The statmount api took a different route, but for getting an O_PATH
file this would be a very natural interface without added syscalls.

Thanks,
Miklos
