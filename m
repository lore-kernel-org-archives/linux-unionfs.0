Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E8453BE
	for <linux-unionfs@vger.kernel.org>; Tue, 12 Mar 2024 18:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710267180; cv=none; b=F2thJRe4PdaB1p4ZRr3uwrZrMMO3T9LMQxUbH09Tr8RniIzQ6wa11dyr3jrWPq3NDx5bTBVR+uF37EHp2WZdQuVHgFXwN6QGci0Om7Q5hJYsAVv8PGYF/319+P9QVr298lFogTf3sK5gTD4CYW1hCyPjKxNBaK8ZEbfz3UFm+U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710267180; c=relaxed/simple;
	bh=1Indxk+lEwFkuhicAnVURL9y1MXW98vjZk5VhHqB0+o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=FqxC1Wp32mge1BxC1I7HdtRVZmbpI4MN5S1yVEx5w7xK4PWsotNh1/7cQuE2KldznhnvT5Nv91Y+CcGnIUydoEkAOs+eEFQXQgPUejF4uqJlthc0d7VuIOfoyqdFw599vJcuwQvUocTpOfTCrCbvB+4fB3yMBHQ9NxkdllVdO/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=G14To7uU; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G14To7uU"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a4627a7233aso15972666b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Mar 2024 11:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710267176; x=1710871976; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1Indxk+lEwFkuhicAnVURL9y1MXW98vjZk5VhHqB0+o=;
        b=G14To7uUggdN52xIpw3ooKDlmLy+59t0aTycz98/BdZry2e5oNsO9mvU+SgxafxxKK
         Jt7cr7DgpEP0bekKTT8druM72JvVRuGtFtuGkAt6S96+cYMEH68NZy1kJGVcvtW6viAu
         tEFYF/wS5fTVMj6+WU4mXnJ+ySwE0WX+gZZVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710267176; x=1710871976;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Indxk+lEwFkuhicAnVURL9y1MXW98vjZk5VhHqB0+o=;
        b=EFi4BkVgjxoXfNBIz20qCpVtvyHn29hjNRoE593h3JDStoBSf/2N446VbVjwcTHv44
         z1SFqTkRL/52TFipi5YodVRalI8MrMSkixcUyCz2459ccFLvgapiZ6dsryR0zJwJ3fyB
         EDXWVhpNmCYbzeGnJbWlX3p7YdfnLUciukoTBMfNSXV6RvjPEfj9vx8u59srhExbDRKu
         06e8FRagguGTM71RNLlcoMvhaEkKHRozQizLxlXyibkfFN5Uqn/dRSTUyS+j+F9FyjTa
         aIm0v+/QJQ07XVU5c8nW9xPSoFFc4IPkTyUvTscqUk7h8SYHcpBZZbG6NhzYPnJsX6//
         P6TA==
X-Gm-Message-State: AOJu0YxX6ziyVcVOZ1lALq5cs5diys00z755pmSjtlYJLw3sCjKgAhUx
	TPG9TZGtPRSGO5l/5pUbLVe15ERY2s3lhVYSpRBI6Fk6j1+CRChSyaSayfbVKEhA0DNev0Oy+VH
	tyw==
X-Google-Smtp-Source: AGHT+IHD6vFYI7puQTKOIf2DlPXHnRUeU10xkyeZ7nAi5QtjmgSySMBpDLqgbV1ONvTZL0z5jy2Ndw==
X-Received: by 2002:a17:906:614:b0:a44:e5ed:3d5d with SMTP id s20-20020a170906061400b00a44e5ed3d5dmr275701ejb.9.1710267176374;
        Tue, 12 Mar 2024 11:12:56 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709067d8800b00a45aeaf9969sm4070378ejo.5.2024.03.12.11.12.55
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 11:12:55 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-565c6cf4819so171471a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Mar 2024 11:12:55 -0700 (PDT)
X-Received: by 2002:a17:906:a08e:b0:a46:4fc3:bc74 with SMTP id
 q14-20020a170906a08e00b00a464fc3bc74mr266723ejy.12.1710267174470; Tue, 12 Mar
 2024 11:12:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Raul Rangel <rrangel@chromium.org>
Date: Tue, 12 Mar 2024 12:12:41 -0600
X-Gmail-Original-Message-ID: <CAHQZ30BFHkt-D65rbxE7MspurQKD8kw2bK2HKxast-RN8ggKfQ@mail.gmail.com>
Message-ID: <CAHQZ30BFHkt-D65rbxE7MspurQKD8kw2bK2HKxast-RN8ggKfQ@mail.gmail.com>
Subject: Accessing bind mount in lower layer via overlayfs
To: linux-unionfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000068a4ea06137a9bec"

--00000000000068a4ea06137a9bec
Content-Type: text/plain; charset="UTF-8"

Hello,
I was wondering if it was possible for the bind mounts created under a
lower layer to be exposed via overlayfs?

I have attached a test script that reproduces what I'm trying to achieve:
$ unshare --user --map-root-user --mount bash -xe mount-test
+ mkdir -p real/usr/lib
+ touch real/usr/lib/foo

+ mkdir -p stage/input
+ mount --bind real stage/input <-- I want to mount `real` under `input`.
+ ls -l stage/input
drwxr-xr-x 3 root root 4096 Mar 12 11:53 usr <-- `usr` is visible.

+ mkdir work upper merged
+ mount -t overlay overlay
-olowerdir=./stage,upperdir=./upper,workdir=./work ./merged
+ ls -Rl merged/input
merged/input:
total 0 <-- The `usr` directory is not passed through.

I wasn't able to find anything that explicitly states it's not
supported. Is something like this possible? I tried setting the mount
propagation to shared, but that didn't have any effect.

Thanks,
Raul

--00000000000068a4ea06137a9bec
Content-Type: application/octet-stream; name=mount-test
Content-Disposition: attachment; filename=mount-test
Content-Transfer-Encoding: base64
Content-ID: <f_ltoofydf0>
X-Attachment-Id: f_ltoofydf0

IyEvYmluL2Jhc2ggLWV4CgpUTVBESVI9IiQobWt0ZW1wIC1kKSIKCmNkICIkVE1QRElSIgoKbWtk
aXIgLXAgcmVhbC91c3IvbGliCnRvdWNoIHJlYWwvdXNyL2xpYi9mb28KCm1rZGlyIC1wIHN0YWdl
L2lucHV0Cm1vdW50IC0tYmluZCByZWFsIHN0YWdlL2lucHV0CgpscyAtUmwgc3RhZ2UvaW5wdXQK
Cm1rZGlyIHdvcmsgdXBwZXIgbWVyZ2VkCgptb3VudCAtdCBvdmVybGF5IG92ZXJsYXkgLW9sb3dl
cmRpcj0uL3N0YWdlLHVwcGVyZGlyPS4vdXBwZXIsd29ya2Rpcj0uL3dvcmsgLi9tZXJnZWQKCmxz
IC1SbCBtZXJnZWQvaW5wdXQKCmlmIFtbICEgLWQgbWVyZ2VkL2lucHV0L3VzciBdXTsgdGhlbgoJ
ZWNobyAiYmluZCBtb3VudCBub3QgYWNjZXNzaWJsZSB2aWEgb3ZlcmxheSIKCWV4aXQgMQpmaQo=
--00000000000068a4ea06137a9bec--
