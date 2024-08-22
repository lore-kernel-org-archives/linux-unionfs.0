Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4AA1D0DF1
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724366909; cv=none; b=R5dZhD6ZKWxaN4t+moOtxvGf000515eppd667rT36rdGGb8Zlnjmm9Eyy5qArDSYYFijiQo7eWnZEPhLYIZ6nOMYIe9s8Ja4bo5b63jJHN4tG6eoti9Kn9mt3lkMymyQK+SgWJHobd8m96Pcwk6WU/QFCuYYGA/u3khGRINiJnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724366909; c=relaxed/simple;
	bh=SOjS44+RICJtuypV7ZkYoCMsGmZAXI7ldDEAwMHh1CE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=M3YY2X61Vq3GBgKXYLx6WXJuyZZRw62b3iy5yswetLTrmTUdTT+HUpFP38T/DaTMCyhFsf5UNxnwFsYBBHAT/C/NdmjRTdzLuo9nMCNW3lR0hBujkVeyNaBHEmMJ+L1l4ZbgMUCKvjIz3IGJ+ISOtGOSfNJoQ8EvKxFNxwh6KoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=RKRzOI6e; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RKRzOI6e"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a86883231b4so188351966b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 15:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724366904; x=1724971704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SOjS44+RICJtuypV7ZkYoCMsGmZAXI7ldDEAwMHh1CE=;
        b=RKRzOI6e6tsMtg16iBtjFSHk179D5DGoCffaZiLz/gW+cN7CUmMN79BOOSYz/rw8UV
         dEZezNqfexd1C7Jdjkk7KtGhl4zMytK6KDCC+ijQ9FWfRAZFGXaHrdj2UNN5AwGJHZQO
         jGu8HihKLKdLWhB5k3ewF54oLwFewIZGd0H1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724366904; x=1724971704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SOjS44+RICJtuypV7ZkYoCMsGmZAXI7ldDEAwMHh1CE=;
        b=V4rGQHWFwSzALgGpNDfGelLvW44vw7XVIyBLxxQPfZhek3+ljL1FWQx/rJ31xnnvex
         xG01lKJIug8uut95+3uua4CEEyxV7PbgeqzhdLK8oo/8tkcWxJfgU7mtS9hPNl34760J
         G/JQp3ziTr+nYyP28gFjJ1N3G1RdPPhaF8tgTkFG9XiCvH60ojE75dGImJl6vSu27Uze
         6z+JPznPHENpMfa7LQ28adi0dZy2vheFTOR90ZhSpcET6JL72J2E6XLg5z022/XG4Roo
         jU+TIghzPzTMXkI+9V4hejseWuFe3Q5nDk6GStcyHyPYdfECNQ98nz+k5BVh1QAbZH4K
         QWsg==
X-Gm-Message-State: AOJu0YytkAgvaqDI7c9/z1MuoqgPFwDsxOExU1ImP/qxdhFjZ7V9vNQI
	K0G4MIeRsw/OZ63GqSvNymtT+lGfZyflDlKC0hlQn8p44+EK2TT6nh+pc0F4VRIV/1NC7rEa2m0
	=
X-Google-Smtp-Source: AGHT+IFEoLZ1FEad48h/IQfW/Nka8zo2ku/mlpuXrwXZMcAjcQGI2fPaKQdwRCzpz/xwUXihtnpKzg==
X-Received: by 2002:a17:907:d58f:b0:a80:7c30:a82a with SMTP id a640c23a62f3a-a86a54f45e2mr13801566b.69.1724366904351;
        Thu, 22 Aug 2024 15:48:24 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f4f610dsm172110866b.215.2024.08.22.15.48.23
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 15:48:23 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5bf0261f162so1931233a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 15:48:23 -0700 (PDT)
X-Received: by 2002:a17:907:2cc6:b0:a86:9adb:51ca with SMTP id
 a640c23a62f3a-a86a52b1e56mr14965766b.24.1724366902877; Thu, 22 Aug 2024
 15:48:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Raul Rangel <rrangel@chromium.org>
Date: Thu, 22 Aug 2024 16:48:10 -0600
X-Gmail-Original-Message-ID: <CAHQZ30DXgctshMVfGRSyHudViapAs0ib=NPJnMR648dydO892g@mail.gmail.com>
Message-ID: <CAHQZ30DXgctshMVfGRSyHudViapAs0ib=NPJnMR648dydO892g@mail.gmail.com>
Subject: Off by one in lowerdir calculation?
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,
We recently upgraded our kernel on our build bots from 6.5.0-45 to
6.8.0-40. During this upgrade we started getting failing with the
following error:
> overlay: too many lower directories, limit is 500

When we need to mount 500+ layers, we create n/500 overlay mounts each
with 500 lowerdirs, we then use those n/500 layers as the lowerdirs to
another overlayfs mount.

I wrote a little script that can reproduce it: https://paste.myconan.net/50=
1972

If I invoke it with `unshare -mr ~/tmp/overlay-test 500 100` it fails,
but if I invoke it with `unshare -mr ~/tmp/overlay-test 499 100` it
works.

Essentially the following command fails:
> mount -t overlay overlay -o lowerdir=3D1:2:3:4:5:6:7:8:9:10:11:12:13:14:1=
5:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:39:4=
0:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:64:6=
5:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:89:9=
0:91:92:93:94:95:96:97:98:99:100:101:102:103:104:105:106:107:108:109:110:11=
1:112:113:114:115:116:117:118:119:120:121:122:123:124:125:126:127:128:129:1=
30:131:132:133:134:135:136:137:138:139:140:141:142:143:144:145:146:147:148:=
149:150:151:152:153:154:155:156:157:158:159:160:161:162:163:164:165:166:167=
:168:169:170:171:172:173:174:175:176:177:178:179:180:181:182:183:184:185:18=
6:187:188:189:190:191:192:193:194:195:196:197:198:199:200:201:202:203:204:2=
05:206:207:208:209:210:211:212:213:214:215:216:217:218:219:220:221:222:223:=
224:225:226:227:228:229:230:231:232:233:234:235:236:237:238:239:240:241:242=
:243:244:245:246:247:248:249:250:251:252:253:254:255:256:257:258:259:260:26=
1:262:263:264:265:266:267:268:269:270:271:272:273:274:275:276:277:278:279:2=
80:281:282:283:284:285:286:287:288:289:290:291:292:293:294:295:296:297:298:=
299:300:301:302:303:304:305:306:307:308:309:310:311:312:313:314:315:316:317=
:318:319:320:321:322:323:324:325:326:327:328:329:330:331:332:333:334:335:33=
6:337:338:339:340:341:342:343:344:345:346:347:348:349:350:351:352:353:354:3=
55:356:357:358:359:360:361:362:363:364:365:366:367:368:369:370:371:372:373:=
374:375:376:377:378:379:380:381:382:383:384:385:386:387:388:389:390:391:392=
:393:394:395:396:397:398:399:400:401:402:403:404:405:406:407:408:409:410:41=
1:412:413:414:415:416:417:418:419:420:421:422:423:424:425:426:427:428:429:4=
30:431:432:433:434:435:436:437:438:439:440:441:442:443:444:445:446:447:448:=
449:450:451:452:453:454:455:456:457:458:459:460:461:462:463:464:465:466:467=
:468:469:470:471:472:473:474:475:476:477:478:479:480:481:482:483:484:485:48=
6:487:488:489:490:491:492:493:494:495:496:497:498:499:500 ../../merged/0

but this one succeeds (notice I dropped 500):
> mount -t overlay overlay -o lowerdir=3D1:2:3:4:5:6:7:8:9:10:11:12:13:14:1=
5:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:39:4=
0:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:64:6=
5:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:89:9=
0:91:92:93:94:95:96:97:98:99:100:101:102:103:104:105:106:107:108:109:110:11=
1:112:113:114:115:116:117:118:119:120:121:122:123:124:125:126:127:128:129:1=
30:131:132:133:134:135:136:137:138:139:140:141:142:143:144:145:146:147:148:=
149:150:151:152:153:154:155:156:157:158:159:160:161:162:163:164:165:166:167=
:168:169:170:171:172:173:174:175:176:177:178:179:180:181:182:183:184:185:18=
6:187:188:189:190:191:192:193:194:195:196:197:198:199:200:201:202:203:204:2=
05:206:207:208:209:210:211:212:213:214:215:216:217:218:219:220:221:222:223:=
224:225:226:227:228:229:230:231:232:233:234:235:236:237:238:239:240:241:242=
:243:244:245:246:247:248:249:250:251:252:253:254:255:256:257:258:259:260:26=
1:262:263:264:265:266:267:268:269:270:271:272:273:274:275:276:277:278:279:2=
80:281:282:283:284:285:286:287:288:289:290:291:292:293:294:295:296:297:298:=
299:300:301:302:303:304:305:306:307:308:309:310:311:312:313:314:315:316:317=
:318:319:320:321:322:323:324:325:326:327:328:329:330:331:332:333:334:335:33=
6:337:338:339:340:341:342:343:344:345:346:347:348:349:350:351:352:353:354:3=
55:356:357:358:359:360:361:362:363:364:365:366:367:368:369:370:371:372:373:=
374:375:376:377:378:379:380:381:382:383:384:385:386:387:388:389:390:391:392=
:393:394:395:396:397:398:399:400:401:402:403:404:405:406:407:408:409:410:41=
1:412:413:414:415:416:417:418:419:420:421:422:423:424:425:426:427:428:429:4=
30:431:432:433:434:435:436:437:438:439:440:441:442:443:444:445:446:447:448:=
449:450:451:452:453:454:455:456:457:458:459:460:461:462:463:464:465:466:467=
:468:469:470:471:472:473:474:475:476:477:478:479:480:481:482:483:484:485:48=
6:487:488:489:490:491:492:493:494:495:496:497:498:499 ../../merged/0

Could there be a regression in the 6.8 kernel?

Thanks,
Raul
