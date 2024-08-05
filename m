Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C52137C37
	for <linux-unionfs@vger.kernel.org>; Mon,  5 Aug 2024 09:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722851906; cv=none; b=fXXdvQOGmVMRSQ+SnXMIta+CVjUtOkDFEtj5J4bIKcH3eiy9ihG0sBvbN1tnVDbjPzhCS3+UbIXVe9kHJo9zA2mtCvpez3DeInMJBsrzCCh8BpRdw2MOK8EuAJlERGAhPvYlABmvN0EkP/GVfOM7pfciITTwvGgKwpsouoc0iUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722851906; c=relaxed/simple;
	bh=ggWGepl6aKh91iOTWb+1rdBYCJlJhM74VBoIUXBy1Lc=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=mb94fsXQqLd0X4r3ItiH7wHMl4gpXaV0uSuhPwl1kI8HfEnvGRzlLB2pW2qBMfO2SkT6NMel6XB6Pg7vfWzIxx0Ab/lUcFANnZB5fcoo/XrqXIZU2wFkIObk2uTwLUTFiYOFY7L+wiSkVcK9OSH0UaeJL5dmITwBT0qJ4MAlYg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H6zMPgnU; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6zMPgnU"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7a83a968ddso1364937166b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Aug 2024 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722851903; x=1723456703; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ggWGepl6aKh91iOTWb+1rdBYCJlJhM74VBoIUXBy1Lc=;
        b=H6zMPgnUBLchtTbjrmhEJDJeNP1vCDpp92mE2FzXAORMDMBQX4pQD+TxcDGKIEBx7U
         IUK4LrTRFoG0Jiz4Vh3f+i0lT+GFIekBIN7dtwybF8HcvlSnMSxnPoXJqhdapfCIEnDy
         OQtIt9mwRacx0op2cQ/Od/bqEudmNSIfiLKgOjHNG1frXm4WOza7U+/awiScI43D3YY/
         hqt8i9KUA67Awt09ddZyNVcUEJFx3PvtWh/SZoszLq/E0w1vUs8gBmXzPZ6o/GLMZYeN
         Y5JX0AENs0GlbH8uLpil3jYPcsjXYzK9vTTq0bQQ5SpNaJ4Az17+VMqJhFpHo0wzxLYu
         gpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722851903; x=1723456703;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ggWGepl6aKh91iOTWb+1rdBYCJlJhM74VBoIUXBy1Lc=;
        b=MIsRfPzdJ79HIDXhd009kyKAssmrp9vdzjCR29BcS0oYTrzXRUVy505507bdP2cWwC
         fxB3LV1Ue6JUCJOvoG3B1PXw8H+842aFZFKSvXi09Am5HhbhnUia93g5XEmiHYDATpEc
         9+TLAx43T9iZPi32DWYbW/l3+/Au/IrN2+sWsuz4plC9BjIQ/FLuPfvUjWYuGFYXRC1P
         HtiCIhie9p4Uk7UygPiDb4zwRnKnmYjWmZzG7MmU62a0QUWpM74Bi+ChX1yVrPX8xDQo
         S3cAFAe+nHLmlhWvCu5iFy/gOOxHFRMQXePw8IK35w8ZJkfefET+4tS3upKJH4w19+2U
         +ZkQ==
X-Gm-Message-State: AOJu0YxF/5pzFb1j8ev2zqjGzcDOY9VHqamykn/jx2AaAYcSGZLkwRXL
	Muo4L97OHlqOVTDCLJ2IvbX2fKFd5lD6qVpcEBJYlxem862N3jmW9Og6xvSl+yc=
X-Google-Smtp-Source: AGHT+IHTSvQD9sKeWuRSb4Yae7v7p46XN/aPQaT/UfWtHLzWUvCZpIvGnbAJkwoQiXL8FL7xkvNXfA==
X-Received: by 2002:a17:907:d22:b0:a7d:2fb2:d852 with SMTP id a640c23a62f3a-a7dc50a4b64mr792685766b.52.1722851902538;
        Mon, 05 Aug 2024 02:58:22 -0700 (PDT)
Received: from smtpclient.apple ([193.0.218.31])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9d433fesm438178966b.142.2024.08.05.02.58.21
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2024 02:58:22 -0700 (PDT)
From: Yuriy Belikov <yuriybelikov1@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Documentation contribution guidelines and suggestions? 
Message-Id: <5BB255FB-6370-40F8-B5FF-B4B09887C903@gmail.com>
Date: Mon, 5 Aug 2024 12:58:10 +0300
To: linux-unionfs@vger.kernel.org
X-Mailer: Apple Mail (2.3774.600.62)

Greetings

I am a student intern in CERN and currently work on Overlay FS related =
improvements in CERNVM-FS project (cvmfs repo on Github).=20
I want to expand the documentation for Overlay FS by adding a paragraph =
to redirect_dir passage with an explanation to which values the =
attribute could be set by a system in cases of merely renaming a =
directory and moving a directory to a different directories subtree. As =
well I want to add a bit of details to metacopy option description =
regarding files that are landed in the upper level directory with this =
feature being turned on after metadata modification. Are there any =
nuances that I should read about contributing to documentation on top of =
the linux kernel doc-guide? I have never contributed to linux repo =
before and just want to clarify.


Best wishes,=20
Yuriy=
