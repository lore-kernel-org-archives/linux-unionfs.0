Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13183C1D65
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690418; cv=none; b=JbmxStAsaan1QefO5y6xkZDV1UpDa2MfFYRGTO6CEObRALKQDyCcopS7tfp17TlaiTmPbBky3IX9BCLkwsSaNu0XCz7IIagAhLl2UdkpvKM//J+c4ggELzUziH9cMz5pbv8C/zukdwWlOaFEgGzwWT0jpuZzl2sAAIwJSTmLvho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690418; c=relaxed/simple;
	bh=MB1KEcVb+uH2ecGVyr4qpLqKb6SbBgJAInb15YOv3bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jS2Tym0IoIMXqiTOyDpvjJzPRdOYiDCOF32CxrRCAOxZWq4aDipAQHHeHdkO5YK2+yOdUdHadI+OaeWT7DPfgqGqwsqUygOOtx0gr+pIsH/tbHXFrsDJzqSvyNvGLUUJOBquTcfNasLTol8EZjNy03Cjz/N0vyem53trfqCsMLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlqnDlBJ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlqnDlBJ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e8185e037so23863195e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 07:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790690413; x=1791295213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x/srKavlgqYlrzFVROF7aG+7+UUAJd3JIGxu7I1XKtY=;
        b=FlqnDlBJ+Yz80ZO1r7yWk6Z3JKIYQl6ehX7Bg3eVFmKOhp8/wH4AnIonKdXycTxKUE
         Cg+3vX6yUMGlM9Ba7L1AKY8R89rQPhhuOEEWjoOsP20f64ArYuIgNZOWGxwQTEq/o9ap
         kuRXJtP+kJ89vmGOrdMCkASwKsDOZXlQqsF2D8uPvhc8yTuD9eCFaVUYxuHDY/1KLk6J
         0A8NmJfEU38xE1O7qtPbzju0qmRKuvq0CcQS0GNJ4hu7tFO5UPfPiuJIkoSX0lfM0cJG
         EFnrij3Xk7K5i7tI4OrawzUMYr/T3JLwK0/lQ3FQi6mnxLeh/5RZbLXBp5UydF3SFYs2
         +j+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790690413; x=1791295213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x/srKavlgqYlrzFVROF7aG+7+UUAJd3JIGxu7I1XKtY=;
        b=BpWFCnW7uIhfXj+qPPxn4BpBOseIg+CiOY05cNLZujuTTZ3zn4Yf24v/kQgNsnvhhr
         AFzmRYoEORS50wIqCROUk3hcwva1WMKYYJHawvfdj5+tAebsNsvGmPOMrmqyDbyd4c+1
         LTzx4u4QvadezvswxLqpOJVX/HcHuEFK7BkrcCGvzYJKJoRBRCiABoC+GAFiZtxAfymq
         3HfRWGJ+kAhKpWsc5IKEm6QcWX83+KibH60kjzZtfrCT7vhAwLy8yhpKEiFLdO7onnAK
         3j64MHWjCwHlCqKy0PsQFggJ9jY8bBl0ibJvKfVrRZa/kb4QJCAWrNwTNvNCe2d6GUwF
         0RZA==
X-Forwarded-Encrypted: i=1; AKwUvByM7TCbuNH/iRnUnSOnYIONgXNb+pmmFuvhR/fp07Fh3mSoQ5J+rFvQqz0oBOVMBv0KT2civlKB8RVoQzfs@vger.kernel.org
X-Gm-Message-State: AFuF++ndjlHKBeIbg+Piz5iLZTnWA4ziFMUAv63hB+jPKZoOKurK1MXa
	hFUiIU+acNoB3N2hQ6d2VBtRhBm4HxHci5FS9zYtnNBYLF53hMBEElk=
X-Gm-Gg: AYBFou1X9XxXksRA8/IUZVzFpQgRpLqkBGkY93qstN+4V+f+dGK6838XFmSUTz1htqX
	jEPU0b/dwqznUOTKDbmEOdJDADVn4js0f/KUXCVJ2sWU8gvi0Urckcj0oFI0824scLLOtRh6WRe
	jBwnGTBA7H9/eRxRZMGBL2bvC7uQbMXeiDS0ksvp7nB1swfEBbkGxI725sGH4Bf/WBELoIyhXEH
	AB3OGhWBfLcGVCzwRffOFfDMKw53sjYMMNWPSJhIOxlnGPG5OLwQaKqIKMK4wtLnjMH17w/F2ks
	0TQTJMkCSpAhtoAYypmaSkCQP0rVIJifkQKaxVVgFyjF/NJRVbuhxO8pcZg152iSrgQnSxDZ+jX
	BRgi6uV0ziJv0IzoN3G7w8ZILVYdVI8PrQlPSPMiUIqk9xMR5FMFl6WtWnIWRIDwg2Jl/hatS2Q
	g2yDISHaRKlmGZRTX+KSvBYcVw4rUAHABWd5h/6KCJLrPDGbBPYlVutSFODePOTsrX+hFGJy/MI
	Z/deqR4dXoIRAQplJEBjPTxyAGC4WqOaNrmN+9Qk+uXxSNrxpMuFrhQHJyyljoctB7Rf6cznZr/
	uGPW2PU=
X-Received: by 2002:a05:600c:4695:b0:49e:7d74:7b7a with SMTP id 5b1f17b1804b1-49ff06b2c70mr225355595e9.6.1790690412769;
        Tue, 29 Sep 2026 07:00:12 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a013cc0255sm7184465e9.1.2026.09.29.07.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 07:00:12 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: krisman@suse.de
Cc: amir73il@gmail.com,
	brauner@kernel.org,
	danielzgtg.opensource@gmail.com,
	hughd@google.com,
	jack@suse.cz,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	tytso@mit.edu
Subject: Re: [PATCH 1/4] shmem: Report casefold setting in mount options
Date: Tue, 29 Sep 2026 16:00:11 +0200
Message-ID: <20260929140011.211148-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928213155.2612039-2-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de> <20260928213155.2612039-2-krisman@suse.de>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Sep 28, 2026 at 05:31:52PM -0400, Gabriel Krisman Bertazi wrote:
> For shmem, casefolding is a mount option.  Report the current encoding
> and casefolding flags in /proc/mounts

This works for me, on 90ddfbd19636 (akpm/mm-unstable), x86_64,
CONFIG_UNICODE=y:

  # mount -t tmpfs -o casefold tmpfs /t
  # grep /t /proc/mounts
  tmpfs /t tmpfs rw,relatime,casefold=utf8-12.1.0 0 0

Tested-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>

Heads-up on one side effect, since mount(8) builds its remount options
from /proc/mounts: once casefold= is listed there, it gets passed back on
every remount.

  # mount -t tmpfs -o casefold tmpfs /t
  [  527.593309] tmpfs: Using encoding : utf8-12.1.0
  # mount -o remount,size=64M /t
  [  527.595716] tmpfs: Using encoding : utf8-12.1.0

That second line is shmem_parse_opt_casefold() running on a remount that
only asked to change size.  It calls utf8_load() each time, and nothing
frees the result - shmem_reconfigure() doesn't look at ctx->encoding and
shmem_free_fc() doesn't unload it.  50000 such remounts grew kmalloc-32 by
~50000 objects; a tmpfs without casefold stays flat.

The leak predates this patch - you can trigger it by passing casefold= on
a remount by hand - so I sent the fix as a separate patch:

https://lore.kernel.org/all/ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com/
