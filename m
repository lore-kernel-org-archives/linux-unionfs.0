MIME-Version: 1.0
In-Reply-To: <1531832738-18097-1-git-send-email-amir73il@gmail.com>
References: <1531832738-18097-1-git-send-email-amir73il@gmail.com>
Date: Tue, 17 Jul 2018 15:44:03 +0200
Message-ID: <CAJfpegsV3jYoA8nst=vwtpRsW4E6eLxn7j_PokKmGX=kapYqUg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix wrong use of impure dir cache in ovl_iterate()
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Aditya Kali <adityakali@google.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jul 17, 2018 at 3:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Only upper dir can be impure, but if we are in the middle of
> iterating a lower real dir, dir could be copied up and marked
> impure. We only want the impure cache if we started iterating
> a real upper dir to begin with.

Makes sense, applied.

Thanks,
Miklos
