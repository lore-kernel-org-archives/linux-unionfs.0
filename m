Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C7513CFBD
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Apr 2024 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185723; cv=none; b=eMHCI8EHbNJX8vix8n4ydQmF9TwMCrcUYViZlsgIKEc+EOIu8tKcEo+XC9JnHKvbL0LOXMqX4km2krFSdhnVsBOUFzoQ6DVzoa0ac/+Y5oh2tQDnDMXEciZJ/BkYM6pxJTGKSdardLtWHq5YE7hRDYdBUYjti/KzVDXkjjuWOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185723; c=relaxed/simple;
	bh=ickDUqtXIq/2pt/ixVMbVjSczdGqFktaKjk2vMC4D+w=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=CDLCAp5HJoVUV/FJw6LKTjt8HRLkC9wKMM9lMkjtnSzPGdljUMnB6vk0GAh94Hm4uWI0miuhu6Gp3Dmw2i1kxxQo2tId0m+lDuzw1UvWPVmvdm9tnQipcpZx+6BvQuIqxBoAKXBKr7/EPQvCX93Zu/GYXBl+piZTsmMoyR+aoYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmXTrOLf; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmXTrOLf"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a526a200879so128831366b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Apr 2024 05:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713185719; x=1713790519; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ickDUqtXIq/2pt/ixVMbVjSczdGqFktaKjk2vMC4D+w=;
        b=jmXTrOLffu2XbrVbQabEUdsZGJpJtZxKIvW3ie3rwks+FQwBKoi6k0FjNTetIcu2F6
         5Qy99fwnwIMuLurBVvZkZixnacgdS2TmF922SmVlUdsKAxqsRmvV0QWqGk1dIXmITcbm
         qAAeftQ1pPONkuxa5qPzpJBiJ7sEvuJQkf6f6dRD5csTtwxFoYiYrgZnwLarmcnEVLx6
         F4Z38QEtIYeqWzBR2ezWZEgDEDF9AXTztGwOKVo8if7kdCSPnPZcZzzZJpsjnCbTzNK4
         IOp11XGnJiWHAPnRO2hk5fl5/4vHwJk8fVrouHt6AumHirm7OI3EA2s4cfd3zcF5vkSy
         kp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713185719; x=1713790519;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ickDUqtXIq/2pt/ixVMbVjSczdGqFktaKjk2vMC4D+w=;
        b=bO2PQvenKLyXVO1xVJioM7Cw7Y8Kfi/13V94g3bVu2mt2Y0jyisxV/tZY686//wnlS
         8+/kG81uS2iCL5mZg5y6qzA0TV0VhItUV514GN5iJxkXSKYVnMLTn4CTSQo1i64pgjWU
         LUC6yxc0bjtZHL4lSJo0wIGHirL0x8XCY0B+QBIRg2KNwEDDFk1sy+ZRNYnTFcr6E0T6
         XsPBMaSk/8CGBHkmgNpHhljj049396gtowwBRhj8u/4WrxVpqE9hQ6gBZk4Np14sav06
         4c/Q3hZS0NKDiRm4ZGhBdap6vbYe74yKQuuREy2PlVZ9beESb/4kfCU5Jy335vOMokiC
         3cwg==
X-Gm-Message-State: AOJu0Ywoj/apj6Ax+0sAb1UdBf+igEjSdn0R5Qg11csyEoAz2434beZT
	JYql35R2SwulHDwTWx/x/j6h+zIidTiAJtgitdruC/iWoTjR3bGMlrKgTQ==
X-Google-Smtp-Source: AGHT+IFnEJipyAGTJzIyNdO1pV8+FKVLjN5/gWr0MgjNFFhsnLb+6MMt+t1eDnMsEHngx8kYv8X6hQ==
X-Received: by 2002:a17:906:1395:b0:a51:a329:cd7d with SMTP id f21-20020a170906139500b00a51a329cd7dmr6708847ejc.4.1713185719115;
        Mon, 15 Apr 2024 05:55:19 -0700 (PDT)
Received: from smtpclient.apple ([193.0.218.31])
        by smtp.gmail.com with ESMTPSA id gc22-20020a170906c8d600b00a534000d525sm688661ejb.158.2024.04.15.05.55.18
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2024 05:55:18 -0700 (PDT)
From: Yuriy Belikov <yuriybelikov1@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Question regarding internals of metacopy=on feature 
Message-Id: <29C3102E-08CC-43D6-BCC0-2CA588A3C5B1@gmail.com>
Date: Mon, 15 Apr 2024 15:55:08 +0300
To: linux-unionfs@vger.kernel.org
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Dear UnionFS team,

My name is Yuriy, and I am currently an intern at CERN, working on the =
CernVM Filesystem (CVMFS) project. Our objective is to enhance the =
performance of the cvmfs_server utility, which is crucial for publishing =
file updates. Given that CVMFS fundamentally relies on union =
filesystems, we are exploring various features of OverlayFS to achieve =
this, specifically considering the metacopy=3Don option.

I have encountered a scenario that is not explicitly covered in the =
OverlayFS documentation: If metadata (e.g., permissions set by chmod) =
are modified for a file that exists only in the lower-layer (and thus =
appears in the union directory but not in the upper-layer), what is the =
type of the filesystem object in the upper layer under these conditions? =
=46rom preliminary tests with metacopy=3Don, it appears that such files =
are visible in the terminal using the ls command. However, as there were =
no modifications to the file content, a copy-up was not triggered. This =
leads to my question about the type of filesystem object represented in =
the upper-layer directory when only metadata is modified. =20


I would greatly appreciate any clarification or additional documentation =
you could provide regarding this matter.


Best regards, =20
Yuriy Belikov=
