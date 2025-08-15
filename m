Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3677F3009EE
	for <linux-unionfs@vger.kernel.org>; Fri, 15 Aug 2025 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272130; cv=none; b=s56xD8m6tmungdf9jGj0TmvmAxvSxxdp9y/t5QAF72wbxLUQYiJ00XvIhENWaVkPLTB0bEKdM3wDvWTY7lcjKpNEIcmvxiczKuXvUizdnXxmLV0mWrTtH7jVjlIdSpnI/wFy7g0uKjPrPumbPyl5tLt56KKlNgxkgdtmdX3k//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272130; c=relaxed/simple;
	bh=UcVBTkiaAfjyxhkAypowdU3iyMDAe18Z7PLGgK+DDbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8fTqwZ4slmtl8TPG+CY5dmsblkeYq3TqURuE2PhysBqY4jITuVUGIcWVB7RyBbxn7D27rMt0E2w7UhHwJeiSdb6MW8I6r4SUNbs8xTzMgKUjRdRTO07ocNoqfwOD5g2LFZybVuhN8ZUOKHcD+JNWJcgRHiSEgoJlo1Qa1XYU6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAToBuWf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAToBuWf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755272128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wajqPBBnPcom4Kwsxt/izQnxID9VykIZCvGlW/eXKBw=;
	b=aAToBuWfE0LBy/LfIYloF5XUe4iuHStaboOvvoESIMKBLKCtiyssCXwwAyRGoQ/Fs3R4vB
	1Luv5KjC9YNjvQQAtSwp7C1RxAhbitFjqNRj4Cc965wS1nivzM4+ukR7Y1RR3Hzh0dAB0T
	j7ySSDq5NLUj4ljUNrEMtyUaDgBkH8Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-vok-xO4zPqySd6lcGkjv2w-1; Fri, 15 Aug 2025 11:35:26 -0400
X-MC-Unique: vok-xO4zPqySd6lcGkjv2w-1
X-Mimecast-MFC-AGG-ID: vok-xO4zPqySd6lcGkjv2w_1755272126
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2445823bc21so43536175ad.3
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Aug 2025 08:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755272126; x=1755876926;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wajqPBBnPcom4Kwsxt/izQnxID9VykIZCvGlW/eXKBw=;
        b=MhkmRCP6w6kc/yXnKiht70FKTBCZpFcUYSV+0nes7MaO37b1cdJLX1cWLrWXv+6wwt
         FTVO05ka+N5M2Ve8aVmv55dfQ2fVSvr4lyTXA3m+3RrDQBLcPQthqkvFGqpI30k4HSNy
         tAWlCXo7eorKn/UUNqcz7wZe9EryFjiAOxHdeRTk45x1UjyUrQKWsP1Rn5GJa0QrbEQV
         aQ3nexcQvPNUl426ZhFO763CFX4K9M8twsBhvGDSg7Y/Z3psj2GiFWuifakcNsljuX7L
         e7DL7/LzKxIyMxyBBaDeJCSDsJKC1qSwYeVn8taUDhwdBu4eOn+H4mZqGaSrbe7Ug+Nc
         Mm2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWENK+Lsj8Ex4q0UIOYsFP+h5bqcAyUYKQtCQTtCIqK7lVlNK6tuQM6ArVMVEkRnZdB3L9BCmYqWy8eyN0i@vger.kernel.org
X-Gm-Message-State: AOJu0YwPk93GuIsYZ70jt3Tzdp8P6crnYDOi8qY9rEjvMeDEdSrgGX1k
	QRlOO5GSyGPf2FNYlXeLlrtjKqsrlaos9DfS5ht3+aK85mYg6J20nlEvMS5hTpYSs1chHuubEvt
	c8DZLF+sVSSAtv/QfcnypkKrmONZUqB4TbrFDydAop2U4d5rrWXGuZXx07NYr6dbJma8=
X-Gm-Gg: ASbGncv4f+oJim0r+7E/GrCbxdZrtAOkGl9+l31nrynS4a5NMLfbK4PvGnaK8TcOXD1
	fYBoZ1Td9V3emHDn9Hb+FNfb9SCLwyH6DxQix5Q5kSTynSUmnh71dpKKFlPeQvooMFvSJ+7AkP9
	dKsY9jz8D3OB2jcgnrCkcjesV7GjEFtdwsRyrjscsXAL05HrzIQeCz31SBO+W13NnBSl6zBZWqz
	elHuUrYkDugjKPCAMMKmR1Wox9KgDhT68NFtSJVx8sVqZfJNzuz2j4k9Tm1kDcKyiGA/9VASPA5
	YJt9v9Mc2p6FJreluYsZPUCzuYRyMqC9ifmZb5KzcmXiVOgoRKDyNXhlMUVGavYI1isEJWdp5WO
	CQhOu
X-Received: by 2002:a17:903:388e:b0:21f:1202:f2f5 with SMTP id d9443c01a7336-2446d5ba0b8mr36712705ad.8.1755272125826;
        Fri, 15 Aug 2025 08:35:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/MOn3qFUjwT6lp/UsjitKwU3PZP0ZcsExwJyu+bqYbZ/DIyeuHTJ0dBeCqaDT2K6ORexiKQ==
X-Received: by 2002:a17:903:388e:b0:21f:1202:f2f5 with SMTP id d9443c01a7336-2446d5ba0b8mr36712445ad.8.1755272125452;
        Fri, 15 Aug 2025 08:35:25 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d50f2d4sm16627635ad.102.2025.08.15.08.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:35:25 -0700 (PDT)
Date: Fri, 15 Aug 2025 23:35:20 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-unionfs@vger.kernel.org, pdaly@redhat.com
Subject: Re: [PATCH] overlay/005: only run for xfs underlying fs
Message-ID: <20250815153520.xzgxwuwc7slt34li@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250815144555.110780-1-zlang@kernel.org>
 <CAOQ4uxjVpVPVfiJPokpmu6pLDmjtYbeDr+j5jNHi8k9bK_2feg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjVpVPVfiJPokpmu6pLDmjtYbeDr+j5jNHi8k9bK_2feg@mail.gmail.com>

On Fri, Aug 15, 2025 at 05:16:51PM +0200, Amir Goldstein wrote:
> On Fri, Aug 15, 2025 at 4:47 PM Zorro Lang <zlang@kernel.org> wrote:
> >
> > When we runs overlay/005 on a system without xfs module, it always
> > fails as "unknown filesystem type xfs", due to this case require xfs
> > to be the underlying fs explicitly:
> >
> >   $MKFS_XFS_PROG -f -n ftype=1 $upper_loop_dev >>$seqres.full 2>&1
> >
> > So notrun this case if the underlying fs isn't 'xfs'.
> 
> It would have been better if instead of mkfs.xfs, we would have
> used a helper to format $upper_loop_dev as $OVL_BASE_FSTYP
> 
> But this is easier, so unless anybody wants to take on the better fix
> 
> Acked-by: Amir Goldstein <amir73il@gmail.com>

Thanks Amir, No matter what kinds of underlying fs are all good?

I saw this case use:

  $MKFS_XFS_PROG -f -n ftype=1 $upper_loop_dev

So I thought it need the xfs ftype feature :-D

> 
> Thanks,
> Amir.
> 
> >
> > Reported-by: Philip Daly <pdaly@redhat.com>
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  tests/overlay/005 | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tests/overlay/005 b/tests/overlay/005
> > index 4c11d5e1b..d396b5cb2 100755
> > --- a/tests/overlay/005
> > +++ b/tests/overlay/005
> > @@ -31,6 +31,7 @@ _cleanup()
> >  # them explicity after test.
> >  _require_scratch_nocheck
> >  _require_loop
> > +[ "$OVL_BASE_FSTYP" = "xfs" ] || _notrun "The underlying fs should be xfs"
> >
> >  # Remove all files from previous tests
> >  _scratch_mkfs
> > --
> > 2.49.0
> >
> >
> 

