From: Richard Weinberger <richard@nod.at>
Subject: Re: overlayfs vs. fscrypt
Date: Wed, 13 Mar 2019 16:30:03 +0100
Message-ID: <3369831.hnip8tpcNh@blindfold>
References: <4603533.ZIfxmiEf7K@blindfold> <CAOQ4uxhqQKzriL0An4Tvzc1E_LffL-z9q1otOW_RdD1ZdKWP3Q@mail.gmail.com> <20190313151633.GA672@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190313151633.GA672@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul Lawrence <paullawrence@google.com>, david@sigma-star.at
List-Id: linux-unionfs@vger.kernel.org

Am Mittwoch, 13. März 2019, 16:16:33 CET schrieb Theodore Ts'o:
> So before we talk about how to make things work from a technical
> perspective, we should consider what the use case happens to be, and
> what are the security requirements.  *Why* are we trying to use the
> combination of overlayfs and fscrypt, and what are the security
> properties we are trying to provide to someone who is relying on this
> combination?

Well, as stated, on (deeply) embedded systems overlayfs is common.
You have a lowerdir with read-only files and an read-write upper dir.
Of course both lower and upper directory need to be encrypted.
In my case ubifs+fscrypt, sometimes also combined with an encrypted+authenticated
squashfs.

Thanks,
//richard
