Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD95166F07
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 09:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724317213; cv=none; b=r8S3skqzaek7EYlbfJ8KuDpO2h+B2uOEQc4PPukN48XLHtITT34q9UFcLfX2x87vs4RMIpVFpBxhBO/NNAYkPAyC7ZAbIeg+Oae0luD+B5i2Qjmzr0CMOkqhMt967mFpDKBbM1fLGe9uZBveyMUUtAdAxzp/X5LTjF9Tss0wfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724317213; c=relaxed/simple;
	bh=b3PxiCEc7kIl3DHgo4veoMD7JVbbi8m+YmaPJXhB+is=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lzXpBMN9yVThG6YLpQ4NK1SEJNaye67T3QoYmukE8HiqiC9UKQxTK+mmLTWO96rpqh0o3Qw0NzE0uX1e4BLtNfg+1XBRqXvdAaWllfnB17d2sR1U76XyL3GMlXxWxwzqMytAv3IAjlZYd7hxqyZhhwrCsqMJd+FVsz6bQxeTY4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=pYaYtlV+; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="pYaYtlV+"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e1654a42cb8so590838276.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 02:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1724317211; x=1724922011; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b3PxiCEc7kIl3DHgo4veoMD7JVbbi8m+YmaPJXhB+is=;
        b=pYaYtlV+ArtLg8ATQLngaU1OqUHKGDN6oJdJk/QyWXYOy+EdR31fFayoyz5NlYby6w
         gLW6B0pME7mvf2k1+6ZJuB5sA31MhCGaIl1Omx6tqmsnM0Kn+0xGxKsq/iVNTC8C/zpG
         oMl/hYXi4US6vdF1Ub78D8NKi8TMAwS0jzjII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724317211; x=1724922011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b3PxiCEc7kIl3DHgo4veoMD7JVbbi8m+YmaPJXhB+is=;
        b=ZEhRTZx4BrSYuanUAH509/9YRHqrs2x3ADcQYVWORR9TRFSceQzENfcWxb7RshZ9in
         QAt//QS6sFOTRF2x8HuNCtmVa95+KfnK+hAOQT/hGokrQJEYwUtDxQQ2A+EcIkg1DprD
         nwCP33TxpVg8vd36saqlG0BCkITFC4d/rGUz5tmfN5Yw9Q140v8849B8UIrRXwVUc+8/
         boaFPICR4rPx8ZkSO/uShjEPHQ81qzUJhkOq+Z6bB2nDBugkV4jef6JJoICIsajkrsa6
         GLK39xI1lAAl/vRo/3KN/iQHbA/NnFI3F/xYmD66LrEe4rpeh+w0VH9+03b3vYXsiHwg
         gNqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQEpDRUbOUvjfclpDRLFGAcDLIG8EiV8s8Xfc8nDUwUob47H6uQm/YHo1fqVxd5KLTB6po6wtbXKiQHXGY@vger.kernel.org
X-Gm-Message-State: AOJu0YziX+g2chUIvrcrisx0noja3bU+dxK02Z2shDogMfGGB957YdHJ
	tW4+DBDCNagGRzv0379x1aQHZPCIsKWDwmGMUpPpofyIBmCyU8vRHdBF9ApXfc8dfvA4SJAwayj
	B4LruJvADDMPyDoobaH3CVlJfPHE4tutrJwXY+A==
X-Google-Smtp-Source: AGHT+IENrQPuEOtdP7yCOlOmyspu0EZ06NFvO4PhVy4yBweMHtPXhR1W9S02Ep9VQ62K8AA64Qsb89j+aX8DLHYlLMA=
X-Received: by 2002:a05:6902:2b86:b0:e13:c773:68c2 with SMTP id
 3f1490d57ef6-e1665564fbdmr6272042276.51.1724317211154; Thu, 22 Aug 2024
 02:00:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822012523.141846-1-vinicius.gomes@intel.com> <20240822012523.141846-17-vinicius.gomes@intel.com>
In-Reply-To: <20240822012523.141846-17-vinicius.gomes@intel.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Aug 2024 10:59:58 +0200
Message-ID: <CAJfpegt+M3RAQbWgfos=rk1iMu7CRhVS1Z5jHSHFpndTOb4Lgw@mail.gmail.com>
Subject: Re: [PATCH v2 16/16] overlayfs: Remove ovl_override_creds_light()
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: brauner@kernel.org, amir73il@gmail.com, hu1.chen@intel.com, 
	malini.bhandaru@intel.com, tim.c.chen@intel.com, mikko.ylinen@intel.com, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Aug 2024 at 03:25, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Remove the declaration of this unsafe helper.
>
> As the GUARD() helper guarantees that the cleanup will run, it is less
> error prone.

This statement is somewhat dubious.

I suggest that unless and until the goto issue can be fixed the
conversion to guards is postponed.

Thanks,
Miklos
