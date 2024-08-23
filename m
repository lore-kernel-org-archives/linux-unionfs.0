Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B597913AD33
	for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724408232; cv=none; b=S35Z1FJlvnXtePeKyPddNOQiSZAINTukszTjhzBdIEBZMsbscS1NkHJMbm5uWlL7EIwMCVJjYPA6aRY5t3AIQ1ahT7SSHpBdOfLeuPcCjX/wPlxp9/NcBx8wZmDXjClKS1lrTZzd5Ash4DSlys9PTzO+id/8mW1km0axco2lHZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724408232; c=relaxed/simple;
	bh=tM17L9g6mmV27g+INN7Kb1v4ZW3chWP05BjRKoFSKyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WzoHsbc0TFgy6bw+DX4krv6hc5Sf3I+h47AkZk0LiBFwyce62Ba9sQ77LTFWg/dpoRbFKKWjOd2kF3h6AGziHY56zv6UUgr9+I+/0UAV5LQ1iipuYoFWBSVdmb3vbOTefMh4/I220JNOmMPUqS0HNuE7d5o4XnD0VQkieZNbxok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8ic+Zve; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8ic+Zve"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-498c64c6833so653314137.2
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 03:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724408229; x=1725013029; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tM17L9g6mmV27g+INN7Kb1v4ZW3chWP05BjRKoFSKyc=;
        b=X8ic+ZveJ6Urk7FldbBHsH15LvuHg7y+tzc8FwflIKkUjG2p7fGH9yzMD9Gx+kwEF4
         EVQMfNciB9epXrGt9O7LhGJCET1RMdLqqH1zRTAb8DP3mFGXvZU0MMn3zeJQxIK/9SAh
         UzT1M6grU7dsWQOT+Vc0DZdINTYeb8yqeH5n5L/iPkO/x2lsqQHUFp1QItWCXiwoDlJv
         Wci1hpOL1Hf2oSaw/+SOt2l2d/fZKSMPz1oeQ5+5+QIgoONgDmC0PsqXdqW/IECrwBwA
         Sre51eIj+qRUHg+XGIpcllG9dGVwnjtmgg9cA0mtU7mUDDhWOKl2XyC5hu1DbKVR76aq
         pcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724408229; x=1725013029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tM17L9g6mmV27g+INN7Kb1v4ZW3chWP05BjRKoFSKyc=;
        b=KhrKHPhYAa7m9t2cnCFF0TkASDujwAoHfUD6Xj4ON+2MxmNiip7BCLIYcEB/yBrrPO
         +RxcrnPci4RgOpOZzYZlXo2Xju6NPVRGLzCwIMOBNk5il2Qoqld/uDGp6xG72Cqug1/1
         CR2bHctWeR9HtF2RRChOlK16+wmgm0Hi96BM0u3VFyEMCcT6xHgk88b144kqpbycKzFa
         SGqp8GlhjRRB9LRXElVrzMU/pDw0Yh1bmtAh+vcc2KkTY4KXk+PqLz+naxvUvp6NljpL
         MQcS2K3j7QcBwsvKMTvGlgFIf6FbG/cGcYbjt+pjyxB7C4qcPAcQ49avvcBgjP2D8xH2
         FCZg==
X-Gm-Message-State: AOJu0YzLUbuz71GlNGPvL4ua7X1XDp3GmBP38E001mxTEqsTnlNgt9SB
	XUqMK0Oq7hutr92V0G+FKWBum/yg2gGnP37ARWVFtFjhIQg/8a/NJLmQInniyextKIYnkgMf/wQ
	A/xAw7jpl4Y4CBWBQ6kRf3GnJh24qpLxUN88=
X-Google-Smtp-Source: AGHT+IGZngzgMAVY8WjvJwqGaVPJiBa81LFl+iWPoe/Kt6MfSM4YwJByw6cwEsp1IaCjhTlinppJewsoY7BrO/IJfyw=
X-Received: by 2002:a05:6102:32c3:b0:493:f097:e5b7 with SMTP id
 ada2fe7eead31-498f4505afamr2245972137.1.1724408229459; Fri, 23 Aug 2024
 03:17:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHQZ30DXgctshMVfGRSyHudViapAs0ib=NPJnMR648dydO892g@mail.gmail.com>
In-Reply-To: <CAHQZ30DXgctshMVfGRSyHudViapAs0ib=NPJnMR648dydO892g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Aug 2024 12:16:58 +0200
Message-ID: <CAOQ4uxj_DRiAvbDNs=HTMG5oieOK9egHhh-VfFSr=qb0XfJJ9Q@mail.gmail.com>
Subject: Re: Off by one in lowerdir calculation?
To: Raul Rangel <rrangel@chromium.org>
Cc: linux-unionfs@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 12:48=E2=80=AFAM Raul Rangel <rrangel@chromium.org>=
 wrote:
>
> Hello,
> We recently upgraded our kernel on our build bots from 6.5.0-45 to
> 6.8.0-40. During this upgrade we started getting failing with the
> following error:
> > overlay: too many lower directories, limit is 500

Hi Raul,

This regression was already reported and a patch to fix it was submitted:
https://lore.kernel.org/linux-unionfs/20240705011510.794025-3-chengzhihao1@=
huawei.com/

However, both me and Miklos were away for a while, so nobody picked it up.

I have now asked Christian to apply the fixes via his vfs tree.
After it gets merged to the upstream kernel, it should be picked up to
the actively
maintained LTS trees.

Thanks,
Amir.

>
> When we need to mount 500+ layers, we create n/500 overlay mounts each
> with 500 lowerdirs, we then use those n/500 layers as the lowerdirs to
> another overlayfs mount.
>
> I wrote a little script that can reproduce it: https://paste.myconan.net/=
501972
>
> If I invoke it with `unshare -mr ~/tmp/overlay-test 500 100` it fails,
> but if I invoke it with `unshare -mr ~/tmp/overlay-test 499 100` it
> works.
>
> Essentially the following command fails:
> > mount -t overlay overlay -o lowerdir=3D1:2:3:4:5:6:7:8:9:10:11:12:13:14=
:15:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:39=
:40:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:64=
:65:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:89=
:90:91:92:93:94:95:96:97:98:99:100:101:102:103:104:105:106:107:108:109:110:=
111:112:113:114:115:116:117:118:119:120:121:122:123:124:125:126:127:128:129=
:130:131:132:133:134:135:136:137:138:139:140:141:142:143:144:145:146:147:14=
8:149:150:151:152:153:154:155:156:157:158:159:160:161:162:163:164:165:166:1=
67:168:169:170:171:172:173:174:175:176:177:178:179:180:181:182:183:184:185:=
186:187:188:189:190:191:192:193:194:195:196:197:198:199:200:201:202:203:204=
:205:206:207:208:209:210:211:212:213:214:215:216:217:218:219:220:221:222:22=
3:224:225:226:227:228:229:230:231:232:233:234:235:236:237:238:239:240:241:2=
42:243:244:245:246:247:248:249:250:251:252:253:254:255:256:257:258:259:260:=
261:262:263:264:265:266:267:268:269:270:271:272:273:274:275:276:277:278:279=
:280:281:282:283:284:285:286:287:288:289:290:291:292:293:294:295:296:297:29=
8:299:300:301:302:303:304:305:306:307:308:309:310:311:312:313:314:315:316:3=
17:318:319:320:321:322:323:324:325:326:327:328:329:330:331:332:333:334:335:=
336:337:338:339:340:341:342:343:344:345:346:347:348:349:350:351:352:353:354=
:355:356:357:358:359:360:361:362:363:364:365:366:367:368:369:370:371:372:37=
3:374:375:376:377:378:379:380:381:382:383:384:385:386:387:388:389:390:391:3=
92:393:394:395:396:397:398:399:400:401:402:403:404:405:406:407:408:409:410:=
411:412:413:414:415:416:417:418:419:420:421:422:423:424:425:426:427:428:429=
:430:431:432:433:434:435:436:437:438:439:440:441:442:443:444:445:446:447:44=
8:449:450:451:452:453:454:455:456:457:458:459:460:461:462:463:464:465:466:4=
67:468:469:470:471:472:473:474:475:476:477:478:479:480:481:482:483:484:485:=
486:487:488:489:490:491:492:493:494:495:496:497:498:499:500 ../../merged/0
>
> but this one succeeds (notice I dropped 500):
> > mount -t overlay overlay -o lowerdir=3D1:2:3:4:5:6:7:8:9:10:11:12:13:14=
:15:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:39=
:40:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:64=
:65:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:89=
:90:91:92:93:94:95:96:97:98:99:100:101:102:103:104:105:106:107:108:109:110:=
111:112:113:114:115:116:117:118:119:120:121:122:123:124:125:126:127:128:129=
:130:131:132:133:134:135:136:137:138:139:140:141:142:143:144:145:146:147:14=
8:149:150:151:152:153:154:155:156:157:158:159:160:161:162:163:164:165:166:1=
67:168:169:170:171:172:173:174:175:176:177:178:179:180:181:182:183:184:185:=
186:187:188:189:190:191:192:193:194:195:196:197:198:199:200:201:202:203:204=
:205:206:207:208:209:210:211:212:213:214:215:216:217:218:219:220:221:222:22=
3:224:225:226:227:228:229:230:231:232:233:234:235:236:237:238:239:240:241:2=
42:243:244:245:246:247:248:249:250:251:252:253:254:255:256:257:258:259:260:=
261:262:263:264:265:266:267:268:269:270:271:272:273:274:275:276:277:278:279=
:280:281:282:283:284:285:286:287:288:289:290:291:292:293:294:295:296:297:29=
8:299:300:301:302:303:304:305:306:307:308:309:310:311:312:313:314:315:316:3=
17:318:319:320:321:322:323:324:325:326:327:328:329:330:331:332:333:334:335:=
336:337:338:339:340:341:342:343:344:345:346:347:348:349:350:351:352:353:354=
:355:356:357:358:359:360:361:362:363:364:365:366:367:368:369:370:371:372:37=
3:374:375:376:377:378:379:380:381:382:383:384:385:386:387:388:389:390:391:3=
92:393:394:395:396:397:398:399:400:401:402:403:404:405:406:407:408:409:410:=
411:412:413:414:415:416:417:418:419:420:421:422:423:424:425:426:427:428:429=
:430:431:432:433:434:435:436:437:438:439:440:441:442:443:444:445:446:447:44=
8:449:450:451:452:453:454:455:456:457:458:459:460:461:462:463:464:465:466:4=
67:468:469:470:471:472:473:474:475:476:477:478:479:480:481:482:483:484:485:=
486:487:488:489:490:491:492:493:494:495:496:497:498:499 ../../merged/0
>
> Could there be a regression in the 6.8 kernel?
>
> Thanks,
> Raul
