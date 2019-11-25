From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 0/5] allow unprivileged overlay mounts
Date: Mon, 25 Nov 2019 16:14:01 +0100
Message-ID: <CAJfpegt_haMDwd6jo3mQzX2vchk_LLMH+V+h4yDs7geLmo4NhA@mail.gmail.com>
References: <20191025112917.22518-1-mszeredi@redhat.com> <87r231rlfj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r231rlfj.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 25, 2019 at 3:43 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Miklos Szeredi <mszeredi@redhat.com> writes:
>
> > Hi Eric,
> >
> > Can you please have a look at this patchset?
> >
> > The most interesting one is the last oneliner adding FS_USERNS_MOUNT;
> > whether I'm correct in stating that this isn't going to introduce any
> > holes, or not...
>
> I will take some time and dig through this.
>
> From a robustness standpoint I worry about the stackable filesystem
> side.  As that is uniquely an attack vector with overlayfs.
>
> There is definitely demand for this.

Hi Eric,

Have you had time to look into this yet?

Thanks,
Miklos
