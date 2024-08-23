Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1442A156C69
	for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724426229; cv=none; b=YbOcdG7O+nhPUQ/i6qD5q3sO+hgpmkHMXXnHoUHivOB0vkMD9Hjp7hJL83H6Ga4IQfHl+T9ekHEpb6MR7WYHPRKDR9SnJDgmlhhr8ghqTJpAyWhGCC2kgh4Ymwzxr2KrH6zqqdl2FUsTzNyfQ6ZOnB+bRglyJhw0zOqfP24vMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724426229; c=relaxed/simple;
	bh=b+OaqcpaZS62Nk6hitw+pk0EjUyvOsLsThE67yHwtuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oqFmqNLuZrp6kWuv6/jm2zn/Vmgyt2JB7/vtsJl4dECE8uAwuPj3Nj1VfrCpC0zEaUyzPi2IRY5SNJPd+Q4zM1aGjKkYSPSucZuoXcaFcgov7sq56rdKPcTXVUMZmgDV3dLhRqLJacGqLabUI4FBw86swcehJZRm6Z722FRuo6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cj9Q9HLt; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cj9Q9HLt"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-27012aa4a74so1340603fac.0
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 08:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724426227; x=1725031027; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+OaqcpaZS62Nk6hitw+pk0EjUyvOsLsThE67yHwtuc=;
        b=cj9Q9HLtJ2I4p5t/0COTJkL3XIY2KJA/piXhgtycoSfuTU3QTPlOvYvgf/Yo1v0apk
         hdyHb33Rezk1gUHemgfO0rCf2h++H1bDv5S+oRlibTox9RusMVK8qgHszCsrybPW8IfD
         UDyflXn4RzIgxyhqowypqxMX0F2dBcnVpqE9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724426227; x=1725031027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+OaqcpaZS62Nk6hitw+pk0EjUyvOsLsThE67yHwtuc=;
        b=ADCZJZqop+15X1XuuOavxBGwfBST45RR6OdMZX41ORNTmAudB2HJMuANfhhU/vDBak
         LREX0j5izoFzKOccDGgeyVDvjwfiZaNlC7DBHd/Jsv3V9/C8h7sNSM/QHddB50dHsBUW
         MlAUrq/myQdySgMfmysGkNwFz5Elz8lVzapINqyDC8P/Fd20u5qRyGY/vKoylbh8EGc9
         8CIyA6yUo5Dz6Tu1JsSMkJvwYXScIUKempyQXTcuUp0eU9LScyWoZvYPnKccDh+ohKXf
         yOsFHdIWSPiF0ql61/0WOWOfZkv5fHfMWb79Qimm8tTX7Ob+f7yFOKG3JImASCsSX/7q
         YaXQ==
X-Gm-Message-State: AOJu0Yw/KuaDiimYlAuAuTQltGGxAP1jRiqbUpnIHncLDkS86b+tcFyj
	OdA8SiR7xgglXEBhSkFwKf8QksQaRBG++9/Uqp2+MzWUXCbtMPGFwgE0asM83X8p0AZBV1k6vUo
	=
X-Google-Smtp-Source: AGHT+IETdxMIRJgZAj8ddmsD3gsoWu64kxLkEHxH1iipZ9SK01Os03g0/Kt1tRNO6876fOVb1cpr8Q==
X-Received: by 2002:a05:6870:5311:b0:25e:170b:4470 with SMTP id 586e51a60fabf-273e66f5273mr2469860fac.50.1724426226858;
        Fri, 23 Aug 2024 08:17:06 -0700 (PDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com. [209.85.210.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd9acdcf7dsm2891062a12.50.2024.08.23.08.17.05
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 08:17:05 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7142e4dddbfso1712992b3a.0
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 08:17:05 -0700 (PDT)
X-Received: by 2002:a05:6a00:4f86:b0:714:19f8:f135 with SMTP id
 d2e1a72fcca58-71445dfdfffmr3063973b3a.21.1724426224708; Fri, 23 Aug 2024
 08:17:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHQZ30DXgctshMVfGRSyHudViapAs0ib=NPJnMR648dydO892g@mail.gmail.com>
 <CAOQ4uxj_DRiAvbDNs=HTMG5oieOK9egHhh-VfFSr=qb0XfJJ9Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxj_DRiAvbDNs=HTMG5oieOK9egHhh-VfFSr=qb0XfJJ9Q@mail.gmail.com>
From: Raul Rangel <rrangel@chromium.org>
Date: Fri, 23 Aug 2024 09:16:50 -0600
X-Gmail-Original-Message-ID: <CAHQZ30BRsOxq_LDmPZsDVKhF_GOc510dQj2pgbrd+s+72B=T4g@mail.gmail.com>
Message-ID: <CAHQZ30BRsOxq_LDmPZsDVKhF_GOc510dQj2pgbrd+s+72B=T4g@mail.gmail.com>
Subject: Re: Off by one in lowerdir calculation?
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 4:17=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Fri, Aug 23, 2024 at 12:48=E2=80=AFAM Raul Rangel <rrangel@chromium.or=
g> wrote:
> >
> > Hello,
> > We recently upgraded our kernel on our build bots from 6.5.0-45 to
> > 6.8.0-40. During this upgrade we started getting failing with the
> > following error:
> > > overlay: too many lower directories, limit is 500
>
> Hi Raul,
>
> This regression was already reported and a patch to fix it was submitted:
> https://lore.kernel.org/linux-unionfs/20240705011510.794025-3-chengzhihao=
1@huawei.com/
>
> However, both me and Miklos were away for a while, so nobody picked it up=
.
>
> I have now asked Christian to apply the fixes via his vfs tree.
> After it gets merged to the upstream kernel, it should be picked up to
> the actively
> maintained LTS trees.

Great, thanks for the confirmation and bug link!

>
> Thanks,
> Amir.
>
> >
> > When we need to mount 500+ layers, we create n/500 overlay mounts each
> > with 500 lowerdirs, we then use those n/500 layers as the lowerdirs to
> > another overlayfs mount.
> >
> > I wrote a little script that can reproduce it: https://paste.myconan.ne=
t/501972
> >
> > If I invoke it with `unshare -mr ~/tmp/overlay-test 500 100` it fails,
> > but if I invoke it with `unshare -mr ~/tmp/overlay-test 499 100` it
> > works.
> >
> > Essentially the following command fails:
> > > mount -t overlay overlay -o lowerdir=3D1:2:3:4:5:6:7:8:9:10:11:12:13:=
14:15:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:=
39:40:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:=
64:65:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:=
89:90:91:92:93:94:95:96:97:98:99:100:101:102:103:104:105:106:107:108:109:11=
0:111:112:113:114:115:116:117:118:119:120:121:122:123:124:125:126:127:128:1=
29:130:131:132:133:134:135:136:137:138:139:140:141:142:143:144:145:146:147:=
148:149:150:151:152:153:154:155:156:157:158:159:160:161:162:163:164:165:166=
:167:168:169:170:171:172:173:174:175:176:177:178:179:180:181:182:183:184:18=
5:186:187:188:189:190:191:192:193:194:195:196:197:198:199:200:201:202:203:2=
04:205:206:207:208:209:210:211:212:213:214:215:216:217:218:219:220:221:222:=
223:224:225:226:227:228:229:230:231:232:233:234:235:236:237:238:239:240:241=
:242:243:244:245:246:247:248:249:250:251:252:253:254:255:256:257:258:259:26=
0:261:262:263:264:265:266:267:268:269:270:271:272:273:274:275:276:277:278:2=
79:280:281:282:283:284:285:286:287:288:289:290:291:292:293:294:295:296:297:=
298:299:300:301:302:303:304:305:306:307:308:309:310:311:312:313:314:315:316=
:317:318:319:320:321:322:323:324:325:326:327:328:329:330:331:332:333:334:33=
5:336:337:338:339:340:341:342:343:344:345:346:347:348:349:350:351:352:353:3=
54:355:356:357:358:359:360:361:362:363:364:365:366:367:368:369:370:371:372:=
373:374:375:376:377:378:379:380:381:382:383:384:385:386:387:388:389:390:391=
:392:393:394:395:396:397:398:399:400:401:402:403:404:405:406:407:408:409:41=
0:411:412:413:414:415:416:417:418:419:420:421:422:423:424:425:426:427:428:4=
29:430:431:432:433:434:435:436:437:438:439:440:441:442:443:444:445:446:447:=
448:449:450:451:452:453:454:455:456:457:458:459:460:461:462:463:464:465:466=
:467:468:469:470:471:472:473:474:475:476:477:478:479:480:481:482:483:484:48=
5:486:487:488:489:490:491:492:493:494:495:496:497:498:499:500 ../../merged/=
0
> >
> > but this one succeeds (notice I dropped 500):
> > > mount -t overlay overlay -o lowerdir=3D1:2:3:4:5:6:7:8:9:10:11:12:13:=
14:15:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:=
39:40:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:=
64:65:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:=
89:90:91:92:93:94:95:96:97:98:99:100:101:102:103:104:105:106:107:108:109:11=
0:111:112:113:114:115:116:117:118:119:120:121:122:123:124:125:126:127:128:1=
29:130:131:132:133:134:135:136:137:138:139:140:141:142:143:144:145:146:147:=
148:149:150:151:152:153:154:155:156:157:158:159:160:161:162:163:164:165:166=
:167:168:169:170:171:172:173:174:175:176:177:178:179:180:181:182:183:184:18=
5:186:187:188:189:190:191:192:193:194:195:196:197:198:199:200:201:202:203:2=
04:205:206:207:208:209:210:211:212:213:214:215:216:217:218:219:220:221:222:=
223:224:225:226:227:228:229:230:231:232:233:234:235:236:237:238:239:240:241=
:242:243:244:245:246:247:248:249:250:251:252:253:254:255:256:257:258:259:26=
0:261:262:263:264:265:266:267:268:269:270:271:272:273:274:275:276:277:278:2=
79:280:281:282:283:284:285:286:287:288:289:290:291:292:293:294:295:296:297:=
298:299:300:301:302:303:304:305:306:307:308:309:310:311:312:313:314:315:316=
:317:318:319:320:321:322:323:324:325:326:327:328:329:330:331:332:333:334:33=
5:336:337:338:339:340:341:342:343:344:345:346:347:348:349:350:351:352:353:3=
54:355:356:357:358:359:360:361:362:363:364:365:366:367:368:369:370:371:372:=
373:374:375:376:377:378:379:380:381:382:383:384:385:386:387:388:389:390:391=
:392:393:394:395:396:397:398:399:400:401:402:403:404:405:406:407:408:409:41=
0:411:412:413:414:415:416:417:418:419:420:421:422:423:424:425:426:427:428:4=
29:430:431:432:433:434:435:436:437:438:439:440:441:442:443:444:445:446:447:=
448:449:450:451:452:453:454:455:456:457:458:459:460:461:462:463:464:465:466=
:467:468:469:470:471:472:473:474:475:476:477:478:479:480:481:482:483:484:48=
5:486:487:488:489:490:491:492:493:494:495:496:497:498:499 ../../merged/0
> >
> > Could there be a regression in the 6.8 kernel?
> >
> > Thanks,
> > Raul
