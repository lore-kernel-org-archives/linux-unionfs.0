MIME-Version: 1.0
Date: Sun, 9 Jun 2019 21:14:38 +0200
References: <20190607010431.11868-1-mcoffin13@gmail.com>
	<20190607205105.21858-1-mcoffin13@gmail.com>
	<CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com>
	<f5b0bddd-678b-bdd9-6fc7-cc9e5b3211e5@gmail.com>
	<CAOQ4uxjQQcrcpxhtu3kAJvGaK+xd5TfNB=7_UnNciGj990DN6Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxjQQcrcpxhtu3kAJvGaK+xd5TfNB=7_UnNciGj990DN6Q@mail.gmail.com>
Message-ID: <CAJfpegvy-Vfc6AEP7+=VfUtfL4izY8AzgoUdvqP4PHnLDEQhNg@mail.gmail.com>
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect defaults
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Matt Coffin <mcoffin13@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jun 8, 2019 at 8:47 PM Amir Goldstein <amir73il@gmail.com> wrote:

> And then every time that a feature needs to be turned off for some reason
> that also needs to be taken into account.
> IOW, I advise against diving into this mess. You have been warned ;-)

Also a much more productive direction would be to optimize building
the docker image based on the specific format used by overlayfs for
readirect_dir/metacopy.

To me it seems like a no-brainer, but I don't know much about docker, so...

Thanks,
Miklos
